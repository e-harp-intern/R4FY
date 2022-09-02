<template>
  <div id="tour-page">
    <h1>{{ tour.name }}</h1>
    <div id="panel">
      <article class="info" id="guide">
        <p class="outline">必要ガイド人数</p>
        <p class="value">{{ tour.guide_num }}名</p>
      </article>
      <article class="info" id="date">
        <p class="outline">日時</p>
        <p class="value">{{ datetime_method(tour.start_datetime) }}</p>
      </article>
      <article class="info" id="state">
        <p class="outline">ツアー実施状態</p>
        <p class="value">{{ tour_state[tour.tour_state_code] }}</p>
      </article>
    </div>
    <div id="grid">
      <div id="num">
        <table class="inline_table">
          <caption>
            参加者人数
          </caption>
          <tr>
            <td>大人</td>
            <td>{{ tour.adult_num }}名</td>
          </tr>
          <tr>
            <td>子供</td>
            <td>{{ tour.child_num }}名</td>
          </tr>
          <tr>
            <td>計</td>
            <td>{{ tour.adult_num + tour.child_num }}名</td>
          </tr>
        </table>
      </div>
      <div class="memo">
        <p id="memo">メモ</p>
        <div class="memo_box">
          <p>{{ tour.memo }}</p>
        </div>
      </div>
    </div>

    <div id="tours_list">
      <table>
        <caption>
          <h2>参加予定一覧</h2>
        </caption>
        <thead>
          <tr>
            <th @click="sortBy('assign')" :class="addClass('assign')">
              {{ $t("table.guide.assign") }}
            </th>
            <th @click="sortBy('name')" :class="addClass('name')">
              {{ $t("table.guide.name") }}
            </th>
            <th @click="sortBy('email')" :class="addClass('email')">
              {{ $t("table.guide.email") }}
            </th>
            <th @click="sortBy('state')" :class="addClass('answered_state')">
              {{ $t("table.guide.answered_state") }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            id="guide_body_tr"
            v-for="schedule in guideschedules"
            :key="schedule.id"
          >
            <td v-if="schedule.assign">〇</td>
            <td v-else></td>
            <td>{{ schedule.name }}</td>
            <td>{{ schedule.email }}</td>
            <td>
              {{ guide_state[schedule.state] }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      tour: {},
      guideschedules: [],
      tourguides: [],
      tour_state: {
        1: this.$t("state.tour.1"),
        2: this.$t("state.tour.2"),
        4: this.$t("state.tour.4"),
        5: this.$t("state.tour.5"),
        8: this.$t("state.tour.8"),
      },
      guide_state: {
        1: this.$t("state.guide.1"),
        2: this.$t("state.guide.2"),
        3: this.$t("state.guide.3"),
      },
      /* テーブルソート */
      sort_key: "",
      sort_asc: true,
    };
  },
  created() {},
  methods: {
    /* 日時成形処理 */
    datetime_method(datetime) {
      datetime = new Date(datetime);
      return this.$t("other.datetime", {
        year: datetime.getUTCFullYear(),
        month: datetime.getUTCMonth() + 1,
        date: datetime.getUTCDate().toString().padStart(2, "0"),
        hours: datetime.getUTCHours().toString().padStart(2, "0"),
        minutes: datetime.getUTCMinutes().toString().padStart(2, "0"),
      });
    },
    /* テーブルソート */

    /* テーブルタイトル選択時、タイトル要素の昇順に並び替える
       もう一度同じタイトルが選択された場合、昇順、降順を切り替える
      並び替えたデータを返す */
    sort_guides() {
      // タイトルが選択されているか判断
      if (this.sort_key !== "") {
        let set = 1;
        // タイトルの選択状態を判断
        if (this.sort_asc) {
          set = 1;
        } else {
          set = -1;
        }
        // ツアーを選択されたタイトルで並び替える
        this.guideschedules.sort((a, b) => {
          if (a[this.sort_key] < b[this.sort_key]) return -1 * set;
          if (a[this.sort_key] > b[this.sort_key]) return 1 * set;
          return 0;
        });
        return this.guideschedules;
      }
      return this.guideschedules;
    },
    /* タイトルが選択された場合に呼び出される処理 */
    sortBy(key) {
      // 前回の選択と同じタイトルを選択された場合、sort_ascを切り替え、昇順降順処理の切り替えを行う
      if (this.sort_key === key) {
        this.sort_asc = !this.sort_asc;
      } else {
        this.sort_asc = true;
      }
      this.sort_key = key;
      this.sort_guides();
    },
    /* タイトルが選択された場合に呼び出される処理 */
    addClass(key) {
      // 昇順降順を管理する
      return {
        asc: this.sort_key === key && this.sort_asc,
        desc: this.sort_key === key && !this.sort_asc,
      };
    },
  },
  async beforeRouteEnter(to, from, next) {
    const guideStateMethod = (answered, possible) => {
      if (answered) {
        if (possible) {
          return 1;
        }
        return 2;
      }
      return 3;
    };
    // ツアー一覧データの取得
    const response = await api.get("/api/v1/tours/detail/2", next);
    // console.log(response);
    const { tour } = response.data;
    const guideschedules = response.data.guide_schedules;
    const tourguides = response.data.tour_guides;

    for (const g of guideschedules) {
      g.name = g.guide.name;
      g.email = g.guide.email;
      g.state = guideStateMethod(g.answered, g.possible);
      g.assign = tourguides.some((u) => u.guide.id === g.guide.id);
    }

    next((vm) => {
      vm.tour = tour;
      vm.guideschedules = guideschedules;
      vm.tourguides = tourguides;
    });
  },
};
</script>

<style lang="scss" scoped>
/*テーブル全体の設定*/
#tours_list table {
  //border-collapse: collapse;
  font-size: 1.25em;
  margin: 0 auto;
  padding: 0;
  width: 100%;
}
/*テーブルの色分け*/
#tours_list table thead tr {
  background-color: var(--color-theme);
  color: var(--color-white);
}
#tours_list table tbody tr:nth-child(odd) {
  background-color: var(--color-gray);
}
#tours_list table tr:nth-child(even) {
  background-color: var(--color-light-gray);
}
/*テーブル内の要素ごとの配置*/
#tours_list table thead th {
  padding: 1em;
}
#tours_list table th,
#tours_list table td {
  padding: 0.35em 1em;
}
//列ごとにalignする
#tours_list table td:nth-of-type(1),
#tours_list table td:nth-of-type(4) {
  text-align: center;
}
h2 {
  margin: 50px 0 0 0;
}

/*#title {
  float: left;
}
#num {
  clear: both;
  float: left;
}
#tour_state,
#memo {
  margin: 0 0 0 auto;
  padding-right: 500px;
  text-align: center;
  display: flex;
  justify-content: flex-end;
}*/
#grid {
  padding-top: 50px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: auto;
} /*
.info {
  display: flex;
  text-align: center;
  justify-content: center;
  flex-flow: column;
}*/
h1 {
  text-align: center;
}
.info {
  display: inline-block;
  width: 100%;
  height: 100px;
  color: var(--color-white);
  text-align: center;
  vertical-align: middle;
  padding: 30px 0;
  margin: 0 12px 12px 0;
}

.value {
  font-size: 2em;
  margin: 0;
}
#guide {
  background-color: var(--color-light);
}
#date {
  background-color: var(--color-green);
}
#state {
  background-color: var(--color-red);
}
#num table {
  margin: auto;
  width: 300px;
  height: 180px;
  text-align: center;
  border-collapse: collapse;
  font-size: 1.25em;
  border: solid 3px var(--color-theme);
}
/*#num table td:nth-of-type(2) {
  text-align: right;
}*/
#num table tr {
  background-color: var(--color-light-gray);
}
#num table tr:last-child {
  border-top: solid 1px var(--color-theme);
}
#title h2,
h3 {
  margin: 0;
}
#num {
  display: grid;
}
#memo {
  text-align: center;
  font-size: 1.25em;
  margin: 0;
}
#panel {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}
.memo_box {
  margin: 0;
  min-width: 50%;
  min-height: 80%;
  background-color: var(--color-light-gray);
  border: solid 3px var(--color-theme);
}
/*テーブルソートの部品*/
.asc::after {
  content: "↓";
}
.desc::after {
  content: "↑";
}
</style>

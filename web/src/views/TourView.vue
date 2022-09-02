<template>
  <div id="tour-page">
    <h1>{{ $t("pages.tours.tour.title") }}</h1>
    <div id="tour-name">{{ tour.name }}</div>

    <!-- 上部の情報パネル -->
    <div id="panel">
      <article class="info" id="guide">
        <p class="outline">
          {{ $t("pages.tours.tour.requirement_guide_num_title") }}
        </p>
        <p class="value">
          {{ $t("common.people_num_unit", { num: tour.guide_num }) }}
        </p>
      </article>
      <article class="info" id="date">
        <p class="outline">{{ $t("common.start_datetime") }}</p>
        <p class="value">{{ datetimeFormat(tour.start_datetime) }}</p>
      </article>
      <article class="info" id="state">
        <p class="outline">{{ $t("pages.tours.tour.tour_state_title") }}</p>
        <p class="value">{{ tour_state[tour.tour_state_code] }}</p>
      </article>
    </div>

    <!-- 参加者情報 -->
    <div id="grid">
      <div id="num">
        <table class="inline_table">
          <caption>
            {{
              $t("table.tour_participant_num.caption")
            }}
          </caption>
          <tr>
            <td>{{ $t("table.tour_participant_num.adult_num") }}</td>
            <td>
              {{ $t("common.people_num_unit", { num: tour.adult_num }) }}
            </td>
          </tr>
          <tr>
            <td>{{ $t("table.tour_participant_num.child_num") }}</td>
            <td>
              {{ $t("common.people_num_unit", { num: tour.child_num }) }}
            </td>
          </tr>
          <tr>
            <td>{{ $t("table.tour_participant_num.sum_num") }}</td>
            <td>
              {{
                $t("common.people_num_unit", {
                  num: tour.adult_num + tour.child_num,
                })
              }}
            </td>
          </tr>
        </table>
      </div>
      <div class="memo">
        <p id="memo">{{ $t("common.memo") }}</p>
        <div class="memo_box">
          {{ tour.memo }}
        </div>
      </div>
    </div>

    <!-- 参加ガイドの一覧 -->
    <h2>{{ $t("pages.tours.tour.guide_list_title") }}</h2>
    <div id="tours_list">
      <table>
        <thead>
          <tr>
            <th @click="sortBy('assign')" :class="addSortClass('assign')">
              {{ $t("table.guide.assign") }}
            </th>
            <th @click="sortBy('name')" :class="addSortClass('name')">
              {{ $t("table.guide.name") }}
            </th>
            <th @click="sortBy('email')" :class="addSortClass('email')">
              {{ $t("table.guide.email") }}
            </th>
            <th @click="sortBy('state')" :class="addSortClass('state')">
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
            <td v-if="schedule.assign">{{ $t("table.guide.assign_mark") }}</td>
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

    <!-- ツアー操作 -->
    <h2>{{ $t("pages.tours.tour.tour_setting_title") }}</h2>
    <ul>
      <li>
        <a @click="alert_disp()" href="javascript:void(0)">
          {{ $t("pages.tours.delete.title") }}
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";
import table from "@/mixins/table";

export default {
  data() {
    return {
      tour: {},
      guideschedules: [],
      tourguides: [],

      /* ツアーの状態テキスト */
      tour_state: {
        1: this.$t("state.tour.1"),
        2: this.$t("state.tour.2"),
        4: this.$t("state.tour.4"),
        5: this.$t("state.tour.5"),
        8: this.$t("state.tour.8"),
      },

      /* ガイド参加可否入力状態テキスト */
      guide_state: {
        1: this.$t("state.guide_participation.1"),
        2: this.$t("state.guide_participation.2"),
        3: this.$t("state.guide_participation.3"),
      },
    };
  },
  created() {},
  methods: {
    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.guideschedules);
    },

    // 日時を指定フォーマットに成形
    datetimeFormat(d) {
      return this.$t("other.datetime", common.datetimeData(d));
    },

    // 中止処理
    alert_disp() {
      if (window.confirm("ツアーの取り消しを実行しますか？")) {
        // 「OK」時の処理終了
        api.delete(`/api/v1/tours/${this.tour.id}`);
        window.alert("ツアーの中止を行いました。");
        this.$router.go({ path: this.$router.currentRoute.path, force: true }); // リロードする
      } else {
        // 「キャンセル」時の処理開始
        window.alert("キャンセルされました"); // 警告ダイアログを表示
      }
    },
  },
  async beforeRouteEnter(to, from, next) {
    // ガイドの予定入力状態をコードに変換
    const guideStateMethod = (answered, possible) => {
      if (!answered) return 3;
      if (possible) return 1;
      return 2;
    };

    // ツアー一覧データの取得
    const response = await api.get(
      `/api/v1/tours/detail/${to.params.id}`,
      next
    );

    // 各種情報のパース
    const { tour } = response.data;
    const guideschedules = response.data.guide_schedules;
    const tourguides = response.data.tour_guides;

    // ネスとした情報を扱いやすいようにコピー
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
#tour-name {
  font-size: 3em;
  text-align: center;
  margin: 0;
}

/*テーブル全体の設定*/
#tours_list table {
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

#grid {
  padding-top: 50px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: auto;
}

.info {
  display: inline-block;
  width: 100%;
  color: var(--color-white);
  text-align: center;
  vertical-align: middle;
  padding: 0.5em 0;
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
  clear: both;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}

.memo_box {
  margin: 0;
  min-width: 50%;
  min-height: 80%;
  background-color: var(--color-light-gray);
  border: solid 3px var(--color-theme);
  padding: 1em;
  box-sizing: border-box;
}
</style>

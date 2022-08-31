<template>
  <div id="tours-list-page">
    <h1>{{ $t("pages.tours.title") }}</h1>
    <table>
      <thead>
        <tr>
          <th @click="sortBy('name')" :class="addClass('name')">
            {{ $t("table.tour.name") }}
          </th>
          <th
            @click="sortBy('start_datetime')"
            :class="addClass('start_datetime')"
          >
            {{ $t("table.tour.start_datetime") }}
          </th>
          <th @click="sortBy('end_datetime')" :class="addClass('end_datetime')">
            {{ $t("table.tour.end_datetime") }}
          </th>
          <th
            @click="sortBy('tour_state_code')"
            :class="addClass('tour_state_code')"
          >
            {{ $t("table.tour.state") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          id="tours_body_tr"
          v-for="tour in tours"
          :key="tour.id"
          @click="urllink(tour.id)"
        >
          <td>{{ tour.name }}</td>
          <td>{{ datetime_method(tour.start_datetime) }}</td>
          <td>{{ datetime_method(tour.end_datetime) }}</td>
          <td>{{ tour_state[tour.tour_state_code] }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      tours: [],
      tour_state: {
        1: this.$t("state.tour.1"),
        2: this.$t("state.tour.2"),
        4: this.$t("state.tour.4"),
        5: this.$t("state.tour.5"),
        8: this.$t("state.tour.8"),
      },
      /* テーブルソート */
      sort_key: "",
      sort_asc: true,
    };
  },
  computed: {},
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
    sort_tours() {
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
        this.tours.sort((a, b) => {
          if (a[this.sort_key] < b[this.sort_key]) return -1 * set;
          if (a[this.sort_key] > b[this.sort_key]) return 1 * set;
          return 0;
        });
        return this.tours;
      }
      return this.tours;
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
      this.sort_tours();
    },
    /* タイトルが選択された場合に呼び出される処理 */
    addClass(key) {
      // 昇順降順を管理する
      return {
        asc: this.sort_key === key && this.sort_asc,
        desc: this.sort_key === key && !this.sort_asc,
      };
    },
    /* ツアーが選択された場合に詳細ページへ遷移する */
    urllink(id) {
      this.$router.push(`/tours/${id}`);
    },
  },
  async beforeRouteEnter(to, from, next) {
    // ツアー一覧データの取得
    const response = await api.get("/api/v1/tours", next);
    const tours = response.data;

    next((vm) => {
      vm.tours = tours;
    });
  },
};
</script>

<style lang="scss" scoped>
/*テーブル全体の設定*/
table {
  margin: 1em auto;
  padding: 0;
  width: 100%;
}
/*テーブルの色分け*/
table thead tr {
  background-color: var(--color-theme);
  color: var(--color-white);
}
table tbody tr:nth-child(odd) {
  background-color: var(--color-gray);
}
table tr:nth-child(even) {
  background-color: var(--color-light-gray);
}
/*テーブル内の要素ごとの配置*/
table thead th {
  font-size: 0.85em;
  padding: 1em;
}
table th,
table td {
  padding: 0.35em 1em;
}
//列ごとにalignする
table td:nth-of-type(2),
table td:nth-of-type(3) {
  text-align: center;
}
/*テーブルソートの部品*/
.asc::after {
  content: "↓";
}
.desc::after {
  content: "↑";
}
/* テーブルマウスオーバー時 */
#tours_body_tr:hover,
#tours_body_tr:focus,
#tours_body_tr:active {
  -webkit-transform: scale(1.01);
  transform: scale(1.01);
  opacity: 0.8;
  cursor: pointer;
}
</style>

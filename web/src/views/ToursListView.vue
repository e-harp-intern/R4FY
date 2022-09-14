<template>
  <div id="tours-list-page">
    <p id="admin_show_name">
      {{
        $t("pages.tours.admin_name_show.welcome_message", {
          admin_name: adminNameShow.name,
        })
      }}
    </p>
    <br />
    <h1>{{ $t("pages.tours.title") }}</h1>
    <button @click="goTourDetail('create')" id="create_tour_btn">
      {{ $t("pages.tours.create.title") }}
    </button>
    <table class="table-normal">
      <thead>
        <tr>
          <th @click="sortBy('id')" :class="addSortClass('id')">
            {{ $t("table.tour.id") }}
          </th>
          <th @click="sortBy('name')" :class="addSortClass('name')">
            {{ $t("table.tour.name") }}
          </th>
          <th
            @click="sortBy('start_datetime')"
            :class="addSortClass('start_datetime')"
          >
            {{ $t("table.tour.start_datetime") }}
          </th>
          <th
            @click="sortBy('end_datetime')"
            :class="addSortClass('end_datetime')"
          >
            {{ $t("table.tour.end_datetime") }}
          </th>
          <th
            @click="sortBy('tour_state_code')"
            :class="addSortClass('tour_state_code')"
          >
            {{ $t("table.tour.state") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="tour in tours"
          :key="tour.id"
          @click="goTourDetail(tour.id)"
          class="table-hover"
        >
          <td class="center">{{ tour.id }}</td>
          <td>{{ tour.name }}</td>
          <td class="center">{{ datetimeFormat(tour.start_datetime) }}</td>
          <td class="center">{{ datetimeFormat(tour.end_datetime) }}</td>
          <td :class="addStateClass(tour.tour_state_code)">
            {{ codeToTourStateString(tour.tour_state_code) }}
          </td>
        </tr>
      </tbody>
    </table>
    <div v-if="tours.length === 0">
      <p class="nodata-error">{{ $t("pages.tours.no_data_error") }}</p>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";
import table from "@/mixins/table";

export default {
  data() {
    return {
      tours: [],
      adminNameShow: {},
    };
  },
  computed: {},
  methods: {
    // 共通処理を受け渡し
    codeToTourStateString: (state) => common.codeToTourStateString(state),
    datetimeFormat: (d) => common.datetimeFormat(d),

    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.tours);
    },

    // ツアーが選択された場合に詳細ページへ遷移する
    goTourDetail(id) {
      this.$router.push(`/tours/${id}`);
    },

    // ツアー状態によって色を付ける
    addStateClass(state) {
      return {
        CellState_1: state === 1,
        CellState_2: state === 2,
        CellState_4: state === 4,
        CellState_8: state === 8,
        CellState_256: state === 256,
      };
    },
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  async beforeRouteEnter(to, from, next) {
    // 並列で情報を取得
    await Promise.all([
      api.get("/api/v1/tours", null, next),
      api.get("/api/v1/admins/me", null, next),
    ]).then((result) => {
      // 情報を分解
      const tours = result[0].data;
      const { admin } = result[1].data;

      // ページへ渡す
      next((vm) => {
        vm.tours = tours;
        vm.adminNameShow = admin;
      });
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";

#create_tour_btn {
  float: right;
  padding: 0.5em 1.3em;
  margin-bottom: 1em;
  background-color: var(--color-green);
  color: var(--color-white);
}

#admin_show_name {
  font-size: 1.25em;
}

/* ------------ データが無い場合の表示 ------------ */

.nodata-error {
  text-align: center;
  padding: 0.5em;
}

/* ------------ 状態によって色を付ける ------------ */

.CellState_1 {
  background-color: var(--color-yellow);
  color: var(--color-white);
}

.CellState_2 {
  background-color: var(--color-light-green);
  color: var(--color-white);
}

.CellState_4 {
  background-color: var(--color-orange);
  color: var(--color-white);
}

.CellState_8 {
  background-color: var(--color-blue);
  color: var(--color-white);
}

.CellState_256 {
  background-color: var(--color-red);
  color: var(--color-white);
}
</style>

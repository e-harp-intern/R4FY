<template>
  <div>
    <!-- テーブル本体 -->
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

    <!-- 表示するデータがない場合 -->
    <div v-if="tours.length === 0">
      <p class="center">{{ $t("components.tours_table.no_data_error") }}</p>
    </div>
  </div>
</template>

<script>
import table from "@/mixins/table";
import common from "@/mixins/common";

export default {
  props: ["tours"],
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
        CellState_32: state === 32,
        CellState_256: state === 256,
      };
    },
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";

/* ------------ 状態によって色を付ける ------------ */

td.CellState_1 {
  background-color: var(--color-tour-state-code-incomplete) !important;
  color: var(--color-white);
}

td.CellState_2 {
  background-color: var(--color-tour-state-code-assigned) !important;
  color: var(--color-white);
}

td.CellState_32 {
  background-color: var(--color-tour-state-code-complete) !important;
  color: var(--color-white);
}

td.CellState_256 {
  background-color: var(--color-tour-state-code-cancel) !important;
  color: var(--color-white);
}
</style>

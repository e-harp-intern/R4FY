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
    <table>
      <thead>
        <tr>
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
          id="tours_body_tr"
          v-for="tour in tours"
          :key="tour.id"
          @click="goTourDetail(tour.id)"
        >
          <td>{{ tour.name }}</td>
          <td>{{ datetimeFormat(tour.start_datetime) }}</td>
          <td>{{ datetimeFormat(tour.end_datetime) }}</td>
          <td>{{ codeToTourStateString(tour.tour_state_code) }}</td>
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
  },
  async beforeRouteEnter(to, from, next) {
    // ツアー一覧データの取得
    const response = await api.get("/api/v1/tours", next);
    const tours = response.data;

    const responceAdmin = await api.get("/api/v1/admins/me", next);
    const adminNameShow = responceAdmin.data;

    next((vm) => {
      vm.tours = tours;
      vm.adminNameShow = adminNameShow;
    });
  },
};
</script>

<style lang="scss" scoped>
/*テーブル全体の設定*/
table {
  clear: both;
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

/* テーブルマウスオーバー時 */
#tours_body_tr:hover,
#tours_body_tr:focus,
#tours_body_tr:active {
  -webkit-transform: scale(1.01);
  transform: scale(1.01);
  opacity: 0.8;
  cursor: pointer;
}
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

.nodata-error {
  text-align: center;
  padding: 0.5em;
}
</style>

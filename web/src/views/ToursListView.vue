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
      {{ $t("button.tour_create") }}
    </button>
    <button type="checkbox" id="search_btn">
      {{ $t("button.searchbar") }}
    </button>

    <br />
    <div class="form-frame">
      <form @submit.prevent="search" class="form-main">
        <div class="form-tabel">
          <!--ツアー名-->
          <label>{{ $t("label.tour_name") }}</label
          ><input
            type="text"
            :placeholder="$t('label.detail.tour_name')"
            id="tour_name"
            required
          />
          <!-- 最大人数 -->
          <label> {{ $t("label.max_num") }} </label>
          <input type="number" name="number" />
          <!--開始日時-->
          <label>{{ $t("label.start_datetime") }}</label
          ><input type="datetime-local" id="start_datetime" required />
          <!--終了日時-->
          <label>{{ $t("label.end_datetime") }}</label
          ><input type="datetime-local" id="end_datetime" required />
          <!-- ツアー状態 --->
          <input type="checkbox" name="state" value="state1" />{{
            $t("state.tour.1")
          }}
          <input type="checkbox" name="state" value="state2" />{{
            $t("state.tour.2")
          }}
          <input type="checkbox" name="state" value="state4" />{{
            $t("state.tour.4")
          }}
          <input type="checkbox" name="state" value="state8" />{{
            $t("state.tour.8")
          }}
          <input type="checkbox" name="state" value="state256" />{{
            $t("state.tour.256")
          }}
        </div>
        <br />
        <div class="form-button-frame">
          <button type="submit" class="button-green">
            {{ $t("button.search") }}
          </button>
        </div>
      </form>
    </div>
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
#search_btn {
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

/* ------------ 検索バー関連 ------------ */

.form-frame {
  margin: 0 auto;
  width: 100%;
  max-width: 950px;
  background-color: var(--color-light-gray);
  box-sizing: border-box;
  border-radius: 0.5em;
}

.form-tabel {
  width: 40%;
  display: inline-grid;
  grid-template-columns: auto 1fr;
  grid-row-gap: 0.5em;
}

.form-tabel label {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.form-main {
  padding: 2em;
}
</style>

<template>
  <div id="tours-list-page">
    <p id="admin_show_name">
      {{
        $t("pages.tours.welcome_message", {
          admin_name: adminNameShow.name,
        })
      }}
    </p>
    <br />
    <h1>{{ $t("pages.tours.title") }}</h1>

    <!-- テーブル上部のボタン -->
    <div class="button-frame">
      <button @click="goTourDetail('create')" class="button-green">
        {{ $t("button.tour_create") }}
      </button>
      <button
        type="checkbox"
        class="button-green"
        @click="isChecking = !isChecking"
      >
        {{ $t("button.searchbar") }}
      </button>
    </div>

    <!-- 詳細検索 -->
    <div class="search-form-frame" v-if="isChecking === true">
      <h3>{{ $t("pages.tours.title_search") }}</h3>
      <form @submit.prevent="search" class="form-main">
        <div class="form-tabel">
          <!--ツアー名-->
          <span class="search-box">
            <label>{{ $t("label.tour_name") }}</label
            ><input
              type="text"
              :placeholder="$t('placeholder.detail.tour_name')"
              id="tour_name"
            />
          </span>

          <!--開始日時-->
          <div class="search-box">
            <label>{{ $t("label.start_datetime") }}</label
            ><input type="date" id="start_datetime" />
            <label> {{ $t("label.time_to") }} </label
            ><input type="date" id="end_datetime" />
          </div>

          <!-- ツアー状態 --->
          <div class="search-box" id="search-from-state">
            <input type="checkbox" id="state1" value="1" checked />
            <label for="state1">{{ $t("state.tour.1") }}</label>
            <input type="checkbox" id="state2" value="2" checked />
            <label for="state2">{{ $t("state.tour.2") }}</label>
            <input type="checkbox" id="state32" value="32" checked />
            <label for="state32">{{ $t("state.tour.32") }}</label>
            <input type="checkbox" id="state256" value="256" checked /><label
              for="state256"
              >{{ $t("state.tour.256") }}</label
            >
          </div>
        </div>

        <!-- 検索ボタン -->
        <div class="form-button-frame">
          <button type="submit" class="button-green">
            {{ $t("button.search") }}
          </button>
        </div>
      </form>
    </div>

    <!-- 一覧テーブル -->
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
      isChecking: false,
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
        CellState_32: state === 32,
        CellState_256: state === 256,
      };
    },
    async search() {
      const url = `/api/v1/tours`;

      const request = {
        word: document.getElementById("tour_name").value,
      };
      // 開始月日
      if (document.getElementById("start_datetime").value !== "") {
        request.start_date = document.getElementById("start_datetime").value;
      }
      // 終了月日
      if (document.getElementById("end_datetime").value !== "") {
        request.end_date = document.getElementById("end_datetime").value;
      }

      const statelist = [];

      if (document.getElementById("state1").checked) {
        statelist.push(1);
      }
      if (document.getElementById("state2").checked) {
        statelist.push(2);
      }
      if (document.getElementById("state32").checked) {
        statelist.push(32);
      }
      if (document.getElementById("state256").checked) {
        statelist.push(256);
      }

      request.tour_state = statelist;

      // 送信
      const response = await api.get(url, request, this.$router.push);

      const tours = response.data;

      // 並び替え
      table.methods.sortBy(null, tours);

      this.tours = tours;
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
  background-color: var(--color-tour-state-code-incomplete);
  color: var(--color-white);
}

.CellState_2 {
  background-color: var(--color-tour-state-code-assigned);
  color: var(--color-white);
}

.CellState_32 {
  background-color: var(--color-tour-state-code-complete);
  color: var(--color-white);
}

.CellState_256 {
  background-color: var(--color-tour-state-code-cancel);
  color: var(--color-white);
}

/* ------------ 検索バー関連 ------------ */

.button-frame {
  display: flex;
  flex-direction: row-reverse;
  margin: 1em;
}

.search-form-frame {
  display: block;
  background-color: var(--color-light-gray);
  border-radius: 0.5em;
  margin-bottom: 1em;
  padding: 0.5em 2em 1em;
}

.form-tabel {
  display: inline-block;
}

.form-button-frame {
  display: flex;
  flex-direction: row-reverse;
}

.search-box {
  padding: 0.5em;
}

#search-from-state > input {
  padding: 0.5em;
  margin-left: 1em;
}

.form-main {
  padding-top: 1em;
}
</style>

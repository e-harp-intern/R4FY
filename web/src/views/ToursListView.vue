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
      <button @click="$router.push('/tours/create')" class="button-green">
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
              :placeholder="$t('placeholder.tour_name')"
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
    <ToursTable :tours="tours"></ToursTable>
  </div>
</template>

<script>
import api from "@/mixins/api";
import table from "@/mixins/table";
import ToursTable from "@/components/ToursTable.vue";

export default {
  components: {
    ToursTable,
  },
  data() {
    return {
      tours: [],
      adminNameShow: {},
      isChecking: false,
    };
  },
  computed: {},
  methods: {
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

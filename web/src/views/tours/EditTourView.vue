<template>
  <div id="create-account-page">
    <h1>{{ $t("pages.tours.edit.title2") }}</h1>
    <div class="form-frame">
      <div class="form-main">
        <div class="form-tabel">
          <!--ツアー名-->
          <label>{{ $t("label.tour_name") }}</label
          ><input
            type="text"
            :placeholder="$t('label.detail.tour_name')"
            id="tour_name"
            required
            v-bind:value="tour.name"
          />
          <!-- 開始日時
          <label>{{ $t("label.start_datetime") }}</label
          ><input
            type="datetime-local"
            id="start_datetime"
            required
            v-bind:value="defaultTime(tour.start_datetime)"
          />
          -->
          <!--終了日時-->
          <!-- <label>{{ $t("label.end_datetime") }}</label
          ><input
            type="datetime-local"
            id="end_datetime"
            required
            v-bind:value="defaultTime(tour.end_datetime)"
          /> -->

          <!--大人-->
          <label>{{ $t("label.adult_num") }}</label
          ><input type="number" id="adult_num" v-bind:value="tour.adult_num" />
          <!--子供-->
          <label>{{ $t("label.child_num") }}</label
          ><input type="number" id="child_num" v-bind:value="tour.child_num" />
          <!--ガイド-->
          <label>{{ $t("label.guide_num") }}</label
          ><input type="number" id="guide_num" v-bind:value="tour.guide_num" />
          <!--参加可否入力期限-->
          <label>{{ $t("label.schedule_input_deadline") }}</label
          ><input
            type="date"
            id="schedule_input_deadline"
            v-bind:value="defaultDate(tour.schedule_input_deadline)"
          />
          <!--メモ-->
          <!-- <label>{{ $t("label.memo") }}</label
          ><textarea
            cols="30"
            rows="5"
            name="memo"
            id="memo"
            v-bind:value="tour.memo"
          >
          </textarea> -->
        </div>
        <hr />
        <!-- リマインドチェック -->
        <div>
          <input
            type="checkbox"
            id="send_remind"
            v-model="tour.send_remind"
          /><label for="send_remind">{{ $t("label.send_remind") }}</label>
        </div>
        <div class="form-button-frame">
          <button class="" @click="$router.back()">
            {{ $t("button.cancel") }}
          </button>
          <button type="submit" @click="change()" class="button-green">
            {{ $t("button.change") }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";
import constant from "@/mixins/constant";

export default {
  data() {
    return {
      tour: [],
    };
  },
  created() {},
  methods: {
    // 共通処理を受け渡し
    codeToTourStateString: (state) => common.codeToTourStateString(state),
    codeToGuideStateString: (state) => common.codeToGuideStateString(state),
    datetimeFormat: (d) => common.datetimeFormat(d),

    // フォームの初期時間設定用
    defaultTime(date) {
      return this.$t("system.datetime", common.datetimeData(date));
    },

    // フォームの初期日付設定用
    defaultDate(date) {
      return this.$t("system.date", common.datetimeData(date));
    },

    async change() {
      // 期限未入力
      if (document.getElementById("schedule_input_deadline").value === "") {
        if (
          !window.confirm(
            this.$t("pages.tours.create.alert_schedule_input_deadline")
          )
        ) {
          window.alert(this.$t("common.cancel"));
          return;
        }
      }

      //   // 現在の時刻を取得
      //   const date = new Date(Date.now());
      //   // 開始日時が過去になっているか確認
      //   if (new Date(document.getElementById("start_datetime").value) < date) {
      //     if (!window.confirm(this.$t("pages.tours.create.alert_start_date"))) {
      //       window.alert(this.$t("common.cancel"));
      //       return;
      //     }
      //   }

      // API
      // ロード中にする
      this.$emit("SendLoadComplete", false);
      // アカウント作成情報を送信
      const response = await api.patch(
        `/api/v1/tours/${this.$route.params.id}`,
        {
          name: document.getElementById("tour_name").value,
          //   start_datetime: document.getElementById("start_datetime").value,
          //   end_datetime: document.getElementById("end_datetime").value,
          adult_num: document.getElementById("adult_num").value,
          child_num: document.getElementById("child_num").value,
          guide_num: document.getElementById("guide_num").value,
          schedule_input_deadline: document.getElementById(
            "schedule_input_deadline"
          ).value,
          send_remind: document.getElementById("send_remind").checked,
          // memo: document.getElementById("memo").value,
        },
        this.$router.push
      );

      // API完了
      if (response.status === "success") {
        // 成功
        this.$router.push(`/tours/${this.$route.params.id}`);
      } else {
        // 失敗
        alert(this.$t("pages.tours.create.create_api_error"));
      }

      this.$emit("SendLoadComplete", true);
    },
  },
  async beforeRouteEnter(to, from, next) {
    // ツアー一覧データの取得
    const response = await api.get(`/api/v1/tours/${to.params.id}`, null, next);

    // 取得エラーでエラーページへ
    if (response.status !== constant.STATE.SUCCESS) {
      next(`/error`);
      return;
    }

    // 各種情報のパース
    const { tour } = response.data;

    // 画面へ情報を渡す
    next((vm) => {
      vm.tour = tour;
    });
  },
};
</script>

<style scoped>
.create-account-page {
  max-width: 100%;
  position: relative;
}

.create-info {
  background-color: var(--color-light-gray);
  border-radius: 1em;
  text-align: center;
  padding: 2em;
}

.form-frame {
  margin: 0 auto;
  width: 100%;
  max-width: 640px;
  background-color: var(--color-light-gray);
  box-sizing: border-box;
  border-radius: 0.5em;
}

.form-tabel {
  width: 80%;
  display: inline-grid;
  grid-template-columns: auto 1fr;
  grid-row-gap: 0.5em;
}

.form-tabel label {
  height: 100%;
  display: flex;
  justify-content: right;
  align-items: center;
}

.form-main {
  padding: 2em;
}

.form-button-frame {
  padding: 2em 2em 0;
  display: flex;
  justify-content: right;
  align-items: center;
}
</style>

<template>
  <div id="create-account-page">
    <h1>{{ $t("pages.tours.change.title2") }}</h1>
    <div class="form-frame">
      <div class="form-main">
        <div class="form-tabel">
          <!--開始日時-->
          <label>{{ $t("label.start_datetime") }}</label
          ><input
            type="datetime-local"
            id="start_datetime"
            required
            v-bind:value="datetimeFormat(tour.start_datetime)"
          />
          <!--終了日時-->
          <label>{{ $t("label.end_datetime") }}</label
          ><input type="datetime-local" id="end_datetime" required />
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
          ><input type="datetime-local" id="schedule_input_deadline" />
          <!--リマインド日-->
          <label>{{ $t("label.remind_date") }}</label
          ><input type="date" id="remind_date" />
          <!--メモ-->
          <label>{{ $t("label.memo") }}</label
          ><textarea
            cols="30"
            rows="5"
            name="memo"
            id="memo"
            v-bind:value="tour.memo"
          >
          </textarea>
        </div>
        <br />
        <div class="form-button-frame">
          <button class="" @click="$router.back()">
            {{ $t("button.cancel") }}
          </button>
          <button type="submit" @click="change" class="button-green">
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

    change() {},
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
    console.log(tour);
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

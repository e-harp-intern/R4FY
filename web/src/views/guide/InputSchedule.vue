<template>
  <div>
    <!-- メッセージ -->
    <div v-if="!isInput && error === 500">
      エラーが発生しました。時間を置いてもう一度お試しください。
    </div>

    <!-- ガイド・ツアー情報 -->
    <div class="tour-info">
      <p>{{ $t("common.name", { name: guide.name }) }}</p>
      <h2>{{ tour.name }}</h2>
      <h3>
        {{
          $t("common.date_start_end", {
            start: datetimeFormat(tour.start_datetime),
            end: datetimeFormat(tour.end_datetime),
          })
        }}
      </h3>
      <p>{{ $t("pages.guides.schedules.info") }}</p>
    </div>

    <!-- フォーム部分 -->
    <div class="form-frame" v-if="!isInput">
      <form @submit.prevent="create" class="form-main">
        <div id="radio">
          <input
            type="radio"
            name="class"
            value="participate"
            id="participate"
          />
          <label for="participate"
            >{{ $t("pages.inputschedule.participate") }}
          </label>
          <br />
          <input type="radio" name="class" value="absent" id="absent" /><label
            for="absent"
            >{{ $t("pages.inputschedule.absent") }}
          </label>
        </div>
        <br />
        <div class="form-button-frame">
          <button type="submit" class="button-green">
            {{ $t("button.send") }}
          </button>
        </div>
      </form>
    </div>

    <!-- 送信完了 -->
    <h2 v-if="isInput">{{ $t("pages.inputschedule.send") }}</h2>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";

export default {
  data() {
    return {
      isInput: false,
      error: null,
      guide: {},
      tour: {},
      is_answered: false,
      is_possible: false,
    };
  },
  created() {},
  methods: {
    // 共通処理の受け渡し
    datetimeFormat: (d) => common.datetimeFormat(d),

    // フォームのリセット
    form_reset() {
      const forms = document.getElementsByTagName("input");
      for (let i = 0; i < forms.length; i += 1) {
        forms[i].value = null;
      }
    },

    // 送信（参加情報を作成）
    async create() {
      // 送信先URL
      const url = `/api/v1/guides/${this.$route.params.token}/schedules`;

      // 送信情報を取得
      const possible = (() => {
        const val = document.querySelector("input[name=class]:checked").value;
        switch (val) {
          case "absent":
            return false;
          case "participate":
            return true;
          default:
            return null;
        }
      })();

      // 送信情報組み立て
      const json = { possible };

      // API通信
      try {
        // ロードアニメーション開始
        this.$emit("SendLoadComplete", false);

        // アカウント作成情報を送信
        const response = await api.patch(url, json, this.$router.push);

        // APIエラー
        if (response.status !== "success") {
          throw new Error("api error");
        }

        // 成功
        this.isInput = true;
        this.form_reset();
      } catch {
        this.error = 500;
      } finally {
        this.$emit("SendLoadComplete", true); // ロードアニメーション終了
      }
    },
  },
  // ページ読み込み時に必要な情報を取得する
  async beforeRouteEnter(to, from, next) {
    // ツアー一覧データの取得
    const { token } = to.params;
    const url = `/api/v1/guides/${token}/schedules`;
    const response = await api.get(url, next);
    const { guide, tour, answered, possible } = response.data;

    // ページへ情報を受け渡し
    next((vm) => {
      vm.guide = guide;
      vm.tour = tour;
      vm.is_answered = answered;
      vm.is_possible = possible;
    });
  },
};
</script>

<style lang="scss" scoped>
.tour-info {
  display: inline-block;
  background-color: var(--color-light-gray);
  border-radius: 0.5em;
  box-sizing: border-box;
  margin: auto;
  width: auto;
  padding: 1em;
  margin: 1em 0;
}
</style>

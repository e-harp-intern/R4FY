<template>
  <div>
    <!-- タイトル -->
    <h1>{{ $t("app_name") }}</h1>

    <!-- メッセージ -->
    <p v-if="error === 500">
      {{ $t("pages.guides.schedules.error") }}
    </p>

    <!-- メッセージ -->
    <p v-if="error === 404">
      {{ $t("pages.guides.schedules.notfound_error") }}
    </p>

    <!-- ガイド・ツアー情報 -->
    <div class="tour-info" v-if="!error">
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

    <!-- フォーム -->
    <div class="form-frame" v-if="!isInput && !error">
      <div class="form-main">
        <div id="select-button-frame">
          <button
            class="button-green"
            :class="buttonGray(is_possible !== null && !is_possible)"
            @click="is_possible = true"
          >
            {{ $t("pages.guides.schedules.button_participate") }}
          </button>
          <button
            class="button-red"
            :class="buttonGray(is_possible !== null && is_possible)"
            @click="is_possible = false"
          >
            {{ $t("pages.guides.schedules.button_absent") }}
          </button>
        </div>
        <div class="form-button-frame">
          <button
            @click="create()"
            class="button-green button-large"
            :class="buttonGray(is_possible === null)"
          >
            {{ $t("button.send") }}
          </button>
        </div>
      </div>
    </div>

    <!-- 送信完了 -->
    <div v-if="isInput">
      <h2>{{ $t("pages.guides.schedules.done_send") }}</h2>
      <p>
        {{ $t("label.send_info") }}
        <span v-if="is_possible">{{
          $t("pages.guides.schedules.button_participate")
        }}</span>
        <span v-else>
          {{ $t("pages.guides.schedules.button_absent") }}
        </span>
      </p>
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
      error: null,
      guide: {},
      tour: {},
      is_answered: null,
      is_possible: null,
      isInput: false,
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

    // ボタンをグレーにする
    buttonGray(flg) {
      return {
        "button-gray": flg,
      };
    },

    // 送信（参加情報を作成）
    async create() {
      // エラーを返す
      if (this.is_possible === null) {
        alert(this.$t("pages.guides.schedules.alert_no_input"));
        return;
      }

      // 送信先URL
      const url = `/api/v1/schedules/${this.$route.params.token}`;

      // 送信情報組み立て
      const json = { possible: this.is_possible };

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
    const url = `/api/v1/schedules/${token}`;
    const response = await api.get(url, null, next);
    const { guide, tour } = response.data;
    const { answered, possible } = response.data.guide_schedule;

    // エラー発生時
    const error = response.status !== constant.STATE.SUCCESS ? 404 : null;

    // ページへ情報を受け渡し
    next((vm) => {
      vm.error = error;
      vm.guide = guide;
      vm.tour = tour;
      vm.is_answered = answered;
      vm.is_possible =
        answered === undefined || answered === false ? null : possible;
      vm.possibleRadio = !answered
        ? ""
        : { true: "participate", false: "absent" }[possible];
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
  margin: 1em 0.5em;
}

.form-button-frame {
  margin-top: 2em;
}

.form-main > * {
  margin-top: 1em;
  font-size: x-large;
}

#select-button-frame {
  display: flex;
  padding: 0.5em;
  box-sizing: border-box;
  justify-content: space-around;
}

#select-button-frame > button {
  display: inline-block;
  flex: 1;
  white-space: nowrap;
}
</style>

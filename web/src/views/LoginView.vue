<template>
  <div id="login">
    <!-- アプリタイトル -->
    <h1>{{ $t("app_name") }}</h1>

    <!-- 通常時の表示 -->
    <div v-if="!password_reset">
      <!-- タイトル -->
      <h2>{{ $t("pages.login.title") }}</h2>

      <!-- 入力フォーム -->
      <div class="form-frame">
        <form @submit.prevent="login" class="login-form">
          <div class="form-tabel">
            <label>{{ $t("label.email") }}</label
            ><input
              type="text"
              :placeholder="$t('placeholder.email')"
              id="email"
            />
            <label>{{ $t("label.password") }}</label
            ><input
              type="password"
              :placeholder="$t('placeholder.password')"
              id="password"
            />
          </div>
          <br />
          <div class="login-button-frame">
            <a href="javascript:void(0)" @click="showPasswordRestMail(true)">{{
              $t("button.password_reset")
            }}</a>
            <button type="submit" class="button-green">
              {{ $t("button.login") }}
            </button>
          </div>
        </form>
      </div>

      <!-- エラー時の表示 -->
      <p v-if="this.error === 401" class="error-info">
        {{ $t("pages.login.error.status_401") }}
      </p>
      <p v-if="this.error === 500" class="error-info">
        {{ $t("pages.login.error.status_500") }}
      </p>

      <!-- 説明 -->
      <div class="login_info">
        <h2>{{ $t("pages.login.info_title") }}</h2>
        <p>{{ $t("pages.login.info") }}</p>
      </div>
    </div>

    <!-- パスワードリセット時の表示 -->
    <div v-else>
      <!-- タイトル -->
      <h2>{{ $t("pages.login.title_reset") }}</h2>

      <!-- 入力フォーム -->
      <div class="form-frame">
        <form @submit.prevent="send_reset_mail" class="login-form">
          <div class="form-tabel">
            <label>{{ $t("label.email") }}</label
            ><input
              type="text"
              :placeholder="$t('placeholder.email')"
              id="reset_email"
            />
          </div>
          <br />
          <div class="login-button-frame">
            <a href="javascript:void(0)" @click="showPasswordRestMail(false)">{{
              $t("button.login")
            }}</a>
            <button type="submit" class="button-green">
              {{ $t("button.send_mail") }}
            </button>
          </div>
        </form>
      </div>

      <!-- 説明 -->
      <div class="login_info">
        <h2>{{ $t("pages.login.info_title") }}</h2>
        <p>{{ $t("pages.login.reset_info") }}</p>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
#login {
  position: relative;

  .form-frame {
    margin: 0 auto;
    width: 640px;
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
  .login-form {
    padding: 2em;
  }
  .login-button-frame {
    padding: 2em 2em 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .login_info {
    display: inline-block;
    width: auto;
    padding: 1em;
    margin: 0 auto;
    margin-top: 2em;
    background-color: var(--color-light-gray);
    border-radius: 0.5em;
    box-sizing: border-box;
  }
  .login_info > p {
    text-align: left;
    line-height: 1.75em;
  }
  .error-info {
    font-weight: bold;
  }
}
</style>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      error: null,
      password_reset: false,
    };
  },
  methods: {
    // パスワードリセット画面切り替え
    showPasswordRestMail(flg) {
      this.password_reset = flg;
    },

    // パスワードリセットメール送信
    async send_reset_mail() {
      // 送信
      const response = await api.post(
        `/api/v1/password/reset`,
        {
          email: document.getElementById("reset_email").value,
        },
        this.$router.push
      );

      // アラート
      if (response.status === "error") {
        alert(this.$t("pages.login.alert_reset_mail_error"));
      } else {
        alert(this.$t("pages.login.alert_reset_mail"));
      }
    },

    async login() {
      const apiLogin = "/api/v1/login";
      const nextPage = "/tours";

      try {
        // ロード中にする
        this.$emit("SendLoadComplete", false);

        // ログイン情報を送信
        const response = await api.post(
          apiLogin,
          {
            email: document.getElementById("email").value,
            password: document.getElementById("password").value,
          },
          this.$router.push
        );

        // API レスポンスを処理
        if (response.status === "success") {
          this.$router.push(nextPage); // ログイン成功
        } else {
          this.error = 401; // ログイン失敗
        }
      } catch {
        this.error = 500;
      } finally {
        this.$emit("SendLoadComplete", true);
      }
    },
  },
};
</script>

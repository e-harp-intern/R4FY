<template>
  <div id="login">
    <!-- アプリタイトル -->
    <h1 class="app-name">{{ $t("app_name") }}</h1>

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
            type="text"
            :placeholder="$t('placeholder.password')"
            id="password"
          />
        </div>
        <br />
        <div class="login-button-frame">
          <router-link to="">{{ $t("button.password_reset") }}</router-link>
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
</template>

<style lang="scss" scoped>
#login {
  position: relative;

  .app-name {
    margin-top: 1.5em;
    border-bottom: 0.1em solid var(--color-theme);
    display: inline-block;
    padding: 0 2em;
    box-sizing: border-box;
  }
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
    };
  },
  methods: {
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

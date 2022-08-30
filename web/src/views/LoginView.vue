<template>
  <div id="login">
    <!-- タイトル -->
    <h1>{{ $t("pages.login.title") }}</h1>

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
    <p v-if="this.error === 401">{{ $t("pages.login.error.status_401") }}</p>
    <p v-if="this.error === 500">{{ $t("pages.login.error.status_500") }}</p>
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
      const nextPage = "/home";

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

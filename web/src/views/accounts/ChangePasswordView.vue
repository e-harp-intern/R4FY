<template>
  <div>
    <h1>{{ $t("pages.password_change.title") }}</h1>

    <!-- 入力フォーム -->
    <div class="form-frame">
      <form @submit.prevent="password_change" class="login-form">
        <div class="form-tabel">
          <label>{{ $t("label.password") }}</label
          ><input
            type="password"
            :placeholder="$t('placeholder.password')"
            id="password"
          />
          <label>{{ $t("label.password_reenter") }}</label
          ><input
            type="password"
            :placeholder="$t('placeholder.password_reenter')"
            id="password_reenter"
          />
        </div>
        <br />
        <div class="login-button-frame">
          <span></span>
          <button type="submit" class="button-green">
            {{ $t("button.change") }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {};
  },
  methods: {
    async password_change() {
      const password = document.getElementById("password").value;
      const re_password = document.getElementById("password_reenter").value;

      // パスワードが違う
      if (password !== re_password) {
        alert(this.$t("pages.password_change.alert_password"));
        return;
      }

      // 送信
      const response = await api.patch(
        `/api/v1/admins/${this.$route.params.id}`,
        {
          password,
        },
        this.$router.push
      );

      // 成功／エラー
      if (response.status === "error") {
        alert(this.$t("pages.password_change.alert_api"));
      } else {
        alert(this.$t("pages.password_change.alert_ok"));
        this.$router.push("/myaccount");
      }
    },
  },
};
</script>

<style lang="scss" scoped>
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
</style>

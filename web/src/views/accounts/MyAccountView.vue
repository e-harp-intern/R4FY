<!-- マイアカウント情報を表示するページ-->
<template>
  <div>
    <h1>{{ $t("pages.myaccount.title") }}</h1>
    <!-- マイアカウント情報をテーブルで表示-->
    <table class="table-normal tabe-margin-0">
      <thead>
        <tr>
          <th>
            {{ $t("table.account.name") }}
          </th>
          <th>
            {{ $t("table.account.email") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>{{ admin.name }}</td>
          <td>{{ admin.email }}</td>
        </tr>
      </tbody>
    </table>
    <button @click="goChangePassword()" id="password_change_btn">
      {{ $t("button.password_change") }}
    </button>
    <button @click="goToChangeMyaccount()" id="password_reset_btn">
      {{ $t("button.myaccount_change") }}
    </button>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      admin: {},
    };
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  methods: {
    // マイアカウント情報変更画面に遷移する
    goToChangeMyaccount() {
      this.$router.push(`/myaccount/${this.admin.id}/change`);
    },
    // パスワードの変更ボタンが押されたときに変更画面に遷移する
    goChangePassword() {
      this.$router.push(`/myaccount/${this.admin.id}/delete`);
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(`/api/v1/admins/me`, null, next);
    // 各種情報のパース
    const { admin } = response.data;
    next((vm) => {
      vm.admin = admin;
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";
#password_change_btn,
#password_reset_btn {
  float: right;
  padding: 0.5em 1.3em;
  margin-bottom: 1em;
  background-color: var(--color-green);
  color: var(--color-white);
}
</style>

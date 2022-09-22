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

    <!-- 操作ボタン -->
    <div class="right">
      <button @click="goEditPassword()" class="button-green">
        {{ $t("button.password_edit") }}
      </button>
      <button @click="goEditMyaccount()" class="button-green">
        {{ $t("button.myaccount_edit") }}
      </button>
    </div>
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
    goEditMyaccount() {
      this.$router.push(`/myaccount/${this.admin.id}/editmyaccount`);
    },
    // パスワードの変更ボタンが押されたときに変更画面に遷移する
    goEditPassword() {
      this.$router.push(`/myaccount/${this.admin.id}/editpassword`);
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
</style>

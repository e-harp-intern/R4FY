<!-- マイアカウント情報を表示するページ-->
<template>
  <div>
    <h1>{{ $t("pages.myaccount.title") }}</h1>
    <button id="password_reset_btn">
      {{ $t("button.password_reset") }}
    </button>
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
  methods: {},
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
#password_reset_btn {
  float: right;
  padding: 0.5em 1.3em;
  margin-bottom: 1em;
  background-color: var(--color-green);
  color: var(--color-white);
}
</style>

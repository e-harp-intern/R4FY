<!-- 管理者の詳細ページ -->
<template>
  <div>
    <h1>{{ $t("pages.accounts.admins.title") }}</h1>

    <!-- 有効なユーザーの場合のみ表示 -->
    <div v-if="!is_invalid">
      <!-- ガイドの情報 -->
      <h2>{{ admin.name }}</h2>
      <ul>
        <li>
          {{ $t("label.email") }}
          <a :href="'mailto:' + admin.email">{{ admin.email }}</a>
        </li>
      </ul>

      <!-- 操作ボタン -->
      <div class="right">
        <button @click="delete_admin()" class="button-red">
          {{ $t("button.delete_admin") }}
        </button>
      </div>
    </div>

    <!-- 削除済み -->
    <div v-else>
      <p>
        {{ $t("pages.accounts.admins.is_invalid") }}<br />
        <a @click="$router.push('/accounts')" href="javascript:void(0)">{{
          $t("pages.accounts.admins.link_accounts_list")
        }}</a>
      </p>

      <!-- 情報 -->
      <ul>
        <li>
          {{ $t("label.name") }}
          {{ admin?.name }}
        </li>
        <li>
          {{ $t("label.email") }}
          <a :href="'mailto:' + admin?.email">{{ admin?.email }}</a>
        </li>
      </ul>

      <!-- 操作 -->
      <button
        class="button-blue"
        @click="reEnableAccount('admins', $route.params.id)"
      >
        {{ $t("button.re_enable_account") }}
      </button>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import constant from "@/mixins/constant";

export default {
  data() {
    return {
      admin: {},
      is_invalid: false,
    };
  },
  methods: {
    // アカウントを復活させる処理
    async reEnableAccount(type, id) {
      // リクエストを送信
      const response = await api.post(
        `/api/v1/${type}/${id}/re_enable`,
        null,
        this.$router.push
      );

      // 失敗時
      if (!(response.status === constant.STATE.SUCCESS)) {
        alert(this.$t("common.alert.on_error"));
        return;
      }

      // 成功時
      alert(this.$t("common.alert.on_success"));
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },

    // アカウントを削除する処理
    async delete_admin() {
      // 警告
      if (
        !window.confirm(this.$t("pages.accounts.admins.alert_delete_warning"))
      ) {
        alert(this.$t("common.alert.operation_aborted"));
        return;
      }

      // 削除を送信
      const response = await api.delete(
        `/api/v1/admins/${this.$route.params.id}`,
        null,
        this.$router.push
      );

      // エラー
      if (response.status !== constant.STATE.SUCCESS) {
        alert(this.$t("pages.accounts.admins.alert_delete_error"));
        return;
      }

      // 成功時
      alert(this.$t("pages.accounts.admins.alert_delete_success"));
      this.$router.push("/accounts");
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(
      `/api/v1/admins/${to.params.id}`,
      null,
      next
    );

    next((vm) => {
      vm.is_invalid = !(response.status === constant.STATE.SUCCESS);
      vm.admin = response.data.admin;
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";
</style>

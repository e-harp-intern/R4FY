<!-- ガイドの詳細ページ -->
<template>
  <div>
    <h1>{{ $t("pages.accounts.guides.title") }}</h1>

    <!-- 有効なユーザーの場合のみ表示 -->
    <div v-if="!is_invalid">
      <!-- ガイドの情報 -->
      <h2>{{ guide.name }}</h2>
      <ul>
        <li>
          {{ $t("label.email") }}
          <a :href="'mailto:' + guide.email">{{ guide.email }}</a>
        </li>
        <li>{{ $t("label.memo") }} {{ guide.memo }}</li>
      </ul>

      <!-- 参加予定のツアー -->
      <h2>{{ $t("pages.accounts.guides.title_assign_tours") }}</h2>
      <ToursTable :tours="assign_tours"></ToursTable>

      <!-- 過去のツアー -->
      <h2>{{ $t("pages.accounts.guides.title_participation_tours") }}</h2>
      <ToursTable :tours="participation_tours"></ToursTable>

      <!-- 操作ボタン -->
      <div class="right">
        <button @click="goToEditGuideInfo(guide.id)" class="button-green">
          {{ $t("button.edit_guide") }}
        </button>
        <button @click="delete_guide()" class="button-red">
          {{ $t("button.delete_guide") }}
        </button>
      </div>
    </div>

    <!-- 削除済み -->
    <div v-else>
      <p>
        {{ $t("pages.accounts.guides.is_invalid") }}<br />
        <a @click="$router.push('/accounts')" href="javascript:void(0)">{{
          $t("pages.accounts.guides.link_accounts_list")
        }}</a>
      </p>

      <!-- ガイドの情報 -->
      <ul>
        <li>
          {{ $t("label.name") }}
          {{ guide?.name }}
        </li>
        <li>
          {{ $t("label.email") }}
          <a :href="'mailto:' + guide?.email">{{ guide?.email }}</a>
        </li>
      </ul>

      <!-- 操作 -->
      <button
        class="button-blue"
        @click="reEnableAccount('guides', $route.params.id)"
      >
        {{ $t("button.re_enable_account") }}
      </button>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import constant from "@/mixins/constant";
import common from "@/mixins/common";
import ToursTable from "@/components/ToursTable.vue";

export default {
  components: {
    ToursTable,
  },
  data() {
    return {
      guide: {},
      achievement: {},
      last_tour: {},
      participation_tours: [],
      assign_tours: [],
      is_invalid: false,
    };
  },
  methods: {
    datetimeFormat: (d) => common.datetimeFormat(d),

    // ツアーが選択された場合に詳細ページへ遷移する
    goTourDetail(id) {
      this.$router.push(`/tours/${id}`);
    },

    goToEditGuideInfo(id) {
      this.$router.push(`/accounts/guides/${id}/edit`);
    },

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

    // ガイドを削除する処理
    async delete_guide() {
      if (window.confirm(this.$t("pages.guides.delete_guide.alert"))) {
        // 「OK」時の処理終了
        await api.delete(`/api/v1/guides/${this.guide.id}`);
        window.alert(this.$t("pages.guides.delete_guide.alert1"));
        this.$router.go({ path: this.$router.currentRoute.path, force: true }); // リロードする
      } else {
        // 「キャンセル」時の処理開始
        window.alert(this.$t("pages.guides.delete_guide.alert2")); // 警告ダイアログを表示
      }
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(
      `/api/v1/guides/${to.params.id}`,
      null,
      next
    );

    next((vm) => {
      vm.is_invalid = !(response.status === "success");
      vm.guide = response.data.guide;
      vm.achievement = response.data.achievement;
      vm.last_tour = response.data.achievement?.last_tour || {};
      vm.assign_tours = response.data.achievement?.assign_tours || {};
      vm.participation_tours =
        response.data.achievement?.participation_tours || [];
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";
</style>

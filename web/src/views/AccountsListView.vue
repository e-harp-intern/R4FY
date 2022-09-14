<template>
  <div id="account-list-page">
    <!-- アカウントの一覧 -->
    <h1>{{ $t("pages.accounts.title") }}</h1>

    <!-- 検索ボックス -->
    <div class="buttons-frame">
      <div class="search-left">
        <button
          class="tab-button"
          :class="{ 'button-theme': table_is_admin }"
          @click="table_is_admin = true"
        >
          {{ $t("account.admin") }}
        </button>
        <button
          class="tab-button"
          :class="{ 'button-theme': !table_is_admin }"
          @click="table_is_admin = false"
        >
          {{ $t("account.guide") }}
        </button>
      </div>
      <div class="search-frame">
        <input class="search-box" type="text" id="name" placeholder="name" />
        <input class="search-box" type="text" id="email" placeholder="email" />
        <button @click="search()">検索</button>
      </div>
      <button @click="gocreatAccount()" id="create_account_btn">
        {{ $t("button.account_create") }}
      </button>
    </div>

    <!-- 一覧テーブル -->
    <table class="table-normal tabe-margin-0">
      <thead>
        <tr>
          <th @click="sortBy('authority')" :class="addSortClass('authority')">
            {{ $t("table.account.authority") }}
          </th>
          <th @click="sortBy('name')" :class="addSortClass('name')">
            {{ $t("table.account.name") }}
          </th>
          <th @click="sortBy('email')" :class="addSortClass('email')">
            {{ $t("table.account.email") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="account in accounts.filter(
            (a) =>
              a.authority ===
              (table_is_admin ? $t('account.admin') : $t('account.guide'))
          )"
          :key="account.number"
          :class="{
            'table-hover': account.authority === $t('account.guide'),
          }"
          @click="tableLink(account.id, account.authority)"
        >
          <td class="center">{{ account.authority }}</td>
          <td>{{ account.name }}</td>
          <td>{{ account.email }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
// import urlJoin from "url-join";
import api from "@/mixins/api";
import table from "@/mixins/table";

export default {
  data() {
    return {
      tour: {},
      admins: [],
      accounts: [],
      guides: [],
      table_is_admin: true,
    };
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  methods: {
    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.accounts);
    },

    // テーブルクリック時の処理
    tableLink(id, type) {
      // 定義
      const type_admin = this.$t("account.admin");
      const type_guide = this.$t("account.guide");

      // URL生成
      let url = "";
      if (type === type_admin) return; // 一時的に無効化
      if (type === type_guide) url = `/accounts/guides/${id}`;
      else {
        alert(this.$t("pages.accounts.link_alert"));
        return;
      }

      // 移動
      this.$router.push(url);
    },

    // ツアーが選択された場合に詳細ページへ遷移する
    gocreatAccount() {
      this.$router.push(`/accounts/create`);
    },
    async search() {
      const url = `/api/v1/accounts`;

      // 送信
      const response = await api.get(
        url,
        {
          name: document.getElementById("name").value,
          email: document.getElementById("email").value,
        },
        this.$router.push
      );

      // 各種情報のパース
      const { admins } = response.data;
      const { guides } = response.data;

      let number = 0;

      for (const a of admins) {
        a.number = number;
        number += 1;
        a.authority = "管理者";
      }
      for (const g of guides) {
        g.number = number;
        number += 1;
        g.authority = "ガイド";
      }
      const accounts = [];
      accounts.push(...admins);
      accounts.push(...guides);

      this.accounts = accounts;
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(`/api/v1/accounts`, null, next);

    // 各種情報のパース
    const { admins } = response.data;
    const { guides } = response.data;

    let number = 0;

    for (const a of admins) {
      a.number = number;
      number += 1;
      a.authority = "管理者";
    }
    for (const g of guides) {
      g.number = number;
      number += 1;
      g.authority = "ガイド";
    }
    const accounts = [];
    accounts.push(...admins);
    accounts.push(...guides);

    next((vm) => {
      vm.accounts = accounts;
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";

h2 {
  margin: 50px 0 0 0;
}

#create_account_btn {
  float: right;
  padding: 0.5em 1.3em;
  background-color: var(--color-green);
  color: var(--color-white);
}

// 検索ボックス
.buttons-frame {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.search-left {
  margin-top: auto;
  margin-right: auto;
}

.tab-button {
  margin: 0 0.1em;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  font-size: large;
  padding: 0.5em 2em;
}

.search-frame {
  display: inline-block;
  background-color: var(--color-light-gray);
  padding: 0.5em;
  border-radius: var(--default-radius);
  margin-bottom: 0.5em;
}

.search-box {
  margin: 0 0.25em;
}
</style>

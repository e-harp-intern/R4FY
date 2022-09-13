<template>
  <div id="account-list-page">
    <!-- アカウントの一覧 -->
    <h1>{{ $t("pages.accounts.title") }}</h1>
    <div class="search">
      <input type="text" id="name" placeholder="name" />
      <input type="text" id="email" placeholder="email" />
      <button @click="search()">検索</button>
      <button @click="gocreatAccount()" id="create_account_btn">
        {{ $t("pages.createaccount.title") }}
      </button>
    </div>
    <div>
      <table class="table-normal">
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
            v-for="account in accounts"
            :key="account.number"
            class="table-hover"
            @click="tableLink(account.id, account.authority)"
          >
            <td class="center">{{ account.authority }}</td>
            <td>{{ account.name }}</td>
            <td>{{ account.email }}</td>
          </tr>
        </tbody>
      </table>
    </div>
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
      if (type === type_admin) url = `/accounts/admins/${id}`;
      else if (type === type_guide) url = `/accounts/guides/${id}`;
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
  margin-bottom: 1em;
  background-color: var(--color-green);
  color: var(--color-white);
}
// 検索ボックス右寄せ
.search {
  text-align: right;
}
</style>

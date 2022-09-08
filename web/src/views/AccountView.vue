<template>
  <div id="account-list-page">
    <!-- アカウントの一覧 -->
    <h1>{{ $t("pages.accounts.title") }}</h1>
    <button @click="gocreatAccount()" id="create_account_btn">
      {{ $t("pages.createaccount.title") }}
    </button>
    <div id="account_list">
      <table>
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
            id="account_body_tr"
            v-for="account in accounts"
            :key="account.number"
          >
            <td>{{ account.authority }}</td>
            <td>{{ account.name }}</td>
            <td>{{ account.email }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
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
  created() {},
  methods: {
    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.accounts);
    },
    // ツアーが選択された場合に詳細ページへ遷移する
    gocreatAccount() {
      this.$router.push(`/accounts/create`);
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(`/api/v1/accounts`, next);

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
/*テーブル全体の設定*/
#account_list table {
  font-size: 1.25em;
  margin: 0 auto;
  padding: 0;
  width: 100%;
}
/*テーブルの色分け*/
#account_list table thead tr {
  background-color: var(--color-theme);
  color: var(--color-white);
}
#account_list table tbody tr:nth-child(odd) {
  background-color: var(--color-gray);
}
#account_list table tr:nth-child(even) {
  background-color: var(--color-light-gray);
}
/*テーブル内の要素ごとの配置*/
#account_list table thead th {
  padding: 1em;
}
#account_list table th,
#account_list table td {
  padding: 0.35em 1em;
}
//列ごとにalignする
#account_list table td:nth-of-type(1),
#account_list table td:nth-of-type(2),
#account_list table td:nth-of-type(4),
#account_list table td:nth-of-type(5) {
  text-align: center;
}
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
</style>

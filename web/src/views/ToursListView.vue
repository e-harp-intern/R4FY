<template>
  <div id="tours-list-page">
    <h1>ツアー一覧確認画面</h1>
    <p>ツアーの一覧確認ができる画面です。説明文続く・・・・・・・・・・</p>
    <table>
      <thead>
        <tr>
          <th>ツアー名</th>
          <th>日時</th>
          <th>状態</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>ツアーサンプルA</td>
          <td>2022-8-29-10:00-15:00</td>
          <td>1</td>
        </tr>
        <tr>
          <td>ツアーサンプルB</td>
          <td>2022-8-29-10:00-15:00</td>
          <td>3</td>
        </tr>
        <tr>
          <td>ツアーサンプルC</td>
          <td>2022-8-29-10:00-15:00</td>
          <td>1</td>
        </tr>
        <tr>
          <td>ツアーサンプルC</td>
          <td>2022-8-29-10:00-15:00</td>
          <td>1</td>
        </tr>
        <tr>
          <td>ツアーサンプルC</td>
          <td>2022-8-29-10:00-15:00</td>
          <td>1</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script></script>

<style lang="scss" scoped>
/*テーブル全体の設定*/
table {
  //border-collapse: collapse;
  margin: 100px auto;
  padding: 0;
  width: 650px;
}
/*テーブルの色分け*/
table thead tr {
  background-color: var(--color-theme);
  color: var(--color-white);
}
table tbody tr:nth-child(odd) {
  background-color: var(--color-gray);
}
table tr:nth-child(even) {
  background-color: var(--color-light-gray);
}
/*テーブル内の要素ごとの配置*/
table thead th {
  font-size: 0.85em;
  padding: 1em;
}
table th,
table td {
  padding: 0.35em 1em;
}
//列ごとにalignする
table td:nth-of-type(2),
table td:nth-of-type(3) {
  text-align: center;
}
</style>

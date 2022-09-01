<template>
  <div id="tour-page">
    <h1>{{ data.tour.name }}</h1>
    <div id="panel">
      <article class="info" id="guide">
        <p class="outline">必要ガイド人数</p>
        <p class="value">2名</p>
      </article>
      <article class="info" id="date">
        <p class="outline">日時</p>
        <p class="value">2022-08-29-10:00</p>
      </article>
      <article class="info" id="state">
        <p class="outline">ツアー実施状態</p>
        <p class="value">実施済</p>
      </article>
    </div>
    <div id="grid">
      <div id="num">
        <table class="inline_table">
          <caption>
            参加者人数
          </caption>
          <tr>
            <td>大人</td>
            <td>5名</td>
          </tr>
          <tr>
            <td>子供</td>
            <td>3名</td>
          </tr>
          <tr>
            <td>計</td>
            <td>8名</td>
          </tr>
        </table>
      </div>
      <div class="memo">
        <p id="memo">メモ</p>
        <textarea name="memo" rows="10" cols="50"></textarea>
      </div>
    </div>

    <div id="tours_list">
      <table>
        <caption>
          <h2>参加予定一覧</h2>
        </caption>
        <thead>
          <tr>
            <th>担当</th>
            <th>名前</th>
            <th>メールアドレス</th>
            <th>参加可否</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>〇</td>
            <td>ガイド 太郎</td>
            <td>guideA@sample.com</td>
            <td>1</td>
          </tr>
          <tr>
            <td>〇</td>
            <td>ガイド 次郎</td>
            <td>guideB@sample.com</td>
            <td>1</td>
          </tr>
          <tr>
            <td>-</td>
            <td>ガイド 三郎</td>
            <td>guideC@sample.com</td>
            <td>1</td>
          </tr>
          <tr>
            <td>-</td>
            <td>ガイド 四郎</td>
            <td>guideD@sample.com</td>
            <td>2</td>
          </tr>
          <tr>
            <td>-</td>
            <td>ガイド 五郎</td>
            <td>guideE@sample.com</td>
            <td>-</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      data: {},
      guideschedule: [],
      tourguide: [],
    };
  },
  created() {},
  methods: {
    form_reset() {
      const forms = document.getElementsByTagName("input");
      for (let i = 0; i < forms.length; i += 1) {
        forms[i].value = null;
      }
    },
  },
  async beforeRouteEnter(to, from, next) {
    // ツアー一覧データの取得
    const response = await api.get("/api/v1/tours/detail/1", next);
    // console.log(response);
    const { data } = response.data;
    const { guideschedule } = response.data;
    const { tourguide } = response.data;

    next((vm) => {
      vm.data = data;
      vm.guideschedule = guideschedule;
      vm.tourguide = tourguide;
    });
  },
};
</script>

<style lang="scss" scoped>
/*テーブル全体の設定*/
#tours_list table {
  //border-collapse: collapse;
  font-size: 1.25em;
  margin: 0 auto;
  padding: 0;
  width: 800px;
}
/*テーブルの色分け*/
#tours_list table thead tr {
  background-color: var(--color-theme);
  color: var(--color-white);
}
#tours_list table tbody tr:nth-child(odd) {
  background-color: var(--color-gray);
}
#tours_list table tr:nth-child(even) {
  background-color: var(--color-light-gray);
}
/*テーブル内の要素ごとの配置*/
#tours_list table thead th {
  padding: 1em;
}
#tours_list table th,
#tours_list table td {
  padding: 0.35em 1em;
}
//列ごとにalignする
#tours_list table td:nth-of-type(1),
#tours_list table td:nth-of-type(4) {
  text-align: center;
}
h2 {
  margin: 50px 0 0 0;
}

/*#title {
  float: left;
}
#num {
  clear: both;
  float: left;
}
#tour_state,
#memo {
  margin: 0 0 0 auto;
  padding-right: 500px;
  text-align: center;
  display: flex;
  justify-content: flex-end;
}*/
#grid {
  padding-top: 50px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: auto;
} /*
.info {
  display: flex;
  text-align: center;
  justify-content: center;
  flex-flow: column;
}*/
h1 {
  text-align: center;
}
.info {
  display: inline-block;
  width: 100%;
  height: 100px;
  color: var(--color-white);
  text-align: center;
  vertical-align: middle;
  padding: 30px 0;
  margin: 0 12px 12px 0;
}

.value {
  font-size: 2em;
  margin: 0;
}
#guide {
  background-color: var(--color-light);
}
#date {
  background-color: var(--color-green);
}
#state {
  background-color: var(--color-red);
}
#num table {
  margin: auto;
  width: 300px;
  height: 180px;
  text-align: center;
  border-collapse: collapse;
  font-size: 1.25em;
  border: solid 3px var(--color-theme);
}
/*#num table td:nth-of-type(2) {
  text-align: right;
}*/
#num table tr {
  background-color: var(--color-light-gray);
}
#num table tr:last-child {
  border-top: solid 1px var(--color-theme);
}
#title h2,
h3 {
  margin: 0;
}
#num {
  display: grid;
}
.memo {
  margin: auto;
}
#memo {
  text-align: center;
  font-size: 1.25em;
  margin: 0;
}
#panel {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}
</style>

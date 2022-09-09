<template>
  <div>
    <!-- タイトル -->
    <h1>ツアー担当ガイド決定画面</h1>

    <!-- 戻る -->
    <ul>
      <li>
        <a @click="$router.back()" href="javascript:void(0);">{{
          $t("common.router_back")
        }}</a>
      </li>
    </ul>

    <!-- 参加ガイドの一覧 -->
    <h2>{{ $t("pages.tours.tour.guide_list_title") }}</h2>
    <div id="tours_list">
      <table>
        <thead>
          <tr>
            <th @click="sortBy('assign')" :class="addSortClass('assign')">
              {{ $t("table.guide.assign") }}
            </th>
            <th @click="sortBy('name')" :class="addSortClass('name')">
              {{ $t("table.guide.name") }}
            </th>
            <th @click="sortBy('email')" :class="addSortClass('email')">
              {{ $t("table.guide.email") }}
            </th>
            <th @click="sortBy('state')" :class="addSortClass('state')">
              {{ $t("table.guide.answered_state") }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            id="guide_body_tr"
            v-for="schedule in guideschedules"
            :key="schedule.id"
            :class="grayoutLine(schedule.state)"
          >
            <td>
              <input
                type="checkbox"
                style="transform: scale(2)"
                id="select-assign"
                name="select-assign"
                v-if="isChecking === buttoncheck(schedule.state)"
              />
            </td>
            <td>{{ schedule.name }}</td>
            <td>{{ schedule.email }}</td>
            <td>
              {{ codeToGuideStateString(schedule.state) }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";
import table from "@/mixins/table";

export default {
  data() {
    return {
      tour: {},
      guideschedules: [],
      tourguides: [],
      isChecking: 1,
    };
  },
  created() {},
  methods: {
    // 共通処理を受け渡し
    codeToGuideStateString: (state) => common.codeToGuideStateString(state),

    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.guideschedules);
    },

    // 参加の有無によってチェックボックスの表示・非表示
    buttoncheck(state) {
      if (state === 1) {
        return 1;
      }
      return 2;
    },

    // 担当割り当てができない場合はグレーアウト
    grayoutLine(state) {
      return {
        grayout: state !== 1,
      };
    },
  },
  async beforeRouteEnter(to, from, next) {
    // ガイドの予定入力状態をコードに変換
    const guideStateMethod = (answered, possible) => {
      if (!answered) return 3;
      if (possible) return 1;
      return 2;
    };

    // ツアー一覧データの取得
    const response = await api.get(`/api/v1/tours/${to.params.id}`, next);

    // 各種情報のパース
    const { tour } = response.data;
    const guideschedules = response.data.guide_schedules;
    const tourguides = response.data.tour_guides;

    // ネスとした情報を扱いやすいようにコピー
    for (const g of guideschedules) {
      g.name = g.guide.name;
      g.email = g.guide.email;
      g.state = guideStateMethod(g.answered, g.possible);
      g.assign = tourguides.some((u) => u.guide.id === g.guide.id);
    }

    // 参加予定を並び替える
    table.methods.sortBy("state", guideschedules);

    // 画面へ情報を受け渡し
    next((vm) => {
      vm.tour = tour;
      vm.guideschedules = guideschedules;
      vm.tourguides = tourguides;
    });
  },
};
</script>

<style lang="scss" scoped>
#tour-name {
  font-size: 3em;
  text-align: center;
  margin: 0;
}

/*テーブル全体の設定*/
#tours_list table {
  font-size: 1.25em;
  margin: 0 auto;
  padding: 0;
  width: 100%;
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
#tours_list table td:nth-of-type(2),
#tours_list table td:nth-of-type(4) {
  text-align: center;
}
h2 {
  margin: 50px 0 0 0;
}

#tours_list table tbody tr.grayout {
  background-color: var(--color-dark-gray);
}
</style>

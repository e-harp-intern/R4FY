<template>
  <div>
    <!-- タイトル -->
    <h1>{{ $t("pages.guides.selectguide.title") }}</h1>

    <!-- 決定ボタン -->
    <div class="center">
      <button
        class="button-green button-large"
        :class="guideNumError()"
        @click="assignGuide()"
      >
        {{ $t("button.assign") }}
      </button>
      <button class="button-large" @click="$router.back()">
        {{ $t("button.cancel") }}
      </button>
    </div>

    <!-- 情報 -->
    <div class="center tour-info">
      {{ currentGuideNum }} {{ $t("pages.guides.selectguide.person2") }}
      {{ tour.guide_num }} {{ $t("pages.guides.selectguide.person") }}
    </div>

    <!-- 参加ガイドの一覧 -->
    <h2>{{ $t("pages.tours.tour.guide_list_title") }}</h2>
    <div>
      <table class="table-normal">
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
            <th>
              {{ $t("table.guide.link") }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="schedule in guideschedules"
            :key="schedule.id"
            :class="tableCSS(schedule.state)"
            class="hover-line"
          >
            <td
              @click="ChangeSelect(schedule.state, schedule.id)"
              class="center"
            >
              <input
                type="checkbox"
                style="transform: scale(2)"
                :id="schedule.id"
                name="select-assign"
                @click="ChangeSelect(schedule.state, schedule.id)"
                v-model="schedule.assign"
                v-if="isChecking === buttoncheck(schedule.state)"
              />
            </td>
            <td @click="ChangeSelect(schedule.state, schedule.id)">
              {{ schedule.name }}
            </td>
            <td @click="ChangeSelect(schedule.state, schedule.id)">
              {{ schedule.email }}
            </td>
            <td
              @click="ChangeSelect(schedule.state, schedule.id)"
              class="center"
            >
              {{ codeToGuideStateString(schedule.state) }}
            </td>
            <td class="center">
              <a
                @click="LinkGuide(schedule.guide_id)"
                href="javascript:void(0)"
                >{{ $t("common.check") }}</a
              >
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
      currentGuideNum: 0,
    };
  },
  created() {
    this.currentGuideNum = this.CountCheckedGuideNum();
  },
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
      return state === 1 ? 1 : 2;
    },

    // ガイドへのリンク
    LinkGuide(id) {
      window.open(`/accounts/guides/${id}`, "_blank");
    },

    // チェック済みガイド数をカウントする
    CountCheckedGuideNum() {
      const num = this.guideschedules.reduce((c, g) => {
        if (g.id === undefined) return c;
        const elem = document.getElementById(g.id);
        if (elem === null) return c;
        c += elem.checked ? 1 : 0;
        return c;
      }, 0);
      return num;
    },

    // チェックボックスを切り替える
    ChangeSelect(state, id) {
      if (state !== 1) {
        return;
      }

      document.getElementById(id).checked =
        !document.getElementById(id).checked;

      // カウントを更新
      this.currentGuideNum = this.CountCheckedGuideNum();
    },

    // 担当割り当てができない場合はグレーアウト
    tableCSS(state) {
      return {
        grayout: state !== 1,
        "table-hover": state === 1,
      };
    },

    // ガイドの数が予定通りなら色を変更
    guideNumError() {
      return {
        guideNumError: this.currentGuideNum !== this.tour.guide_num,
      };
    },

    // 担当ガイドを送信
    async assignGuide() {
      // 予定の人数と違う
      if (this.currentGuideNum !== this.tour.guide_num) {
        if (!window.confirm("ガイドの人数が予定と違いますが、確定しますか？")) {
          window.alert("確定を取り消しました。");
          return;
        }
      }

      // 送信前の確認
      if (!window.confirm("担当が割り当てられたガイドへメールを送信します。")) {
        window.alert("送信を取り消しました。");
        return;
      }

      // 送信メッセージの組み立て
      const guides = [];
      for (const g of this.guideschedules) {
        if (g === null) continue;
        const elem = document.getElementById(g.id);
        if (elem === null || !elem.checked) continue;
        guides.push(g.guide_id);
      }

      // 送信
      try {
        await api.post(
          `/api/v1/tours/${this.tour.id}/guides`,
          { guides },
          this.$router.push
        );
        this.$router.push(`/tours/${this.tour.id}`);
      } catch {
        window.alert("送信エラーが発生しました。");
      }
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
      g.id = `select-assign-${g.guide_id}`;
    }

    // 参加予定を並び替える
    table.methods.sortBy("", guideschedules);
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
@import "@/assets/css/table.scss";

#tour-name {
  font-size: 3em;
  text-align: center;
  margin: 0;
}

h2 {
  margin: 50px 0 0 0;
}

.tour-info {
  padding: 1em;
  box-sizing: border-box;
}

.guideNumError {
  background-color: var(--color-dark-gray);
}
</style>

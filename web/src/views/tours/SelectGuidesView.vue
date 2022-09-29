<template>
  <div>
    <!-- タイトル -->
    <h1>{{ $t("pages.guides.selectguide.title") }}</h1>

    <!-- 決定ボタン -->
    <div class="center">
      <button class="button-large" @click="$router.back()">
        {{ $t("button.cancel") }}
      </button>
      <button
        class="button-green button-large"
        :class="guideNumError()"
        @click="assignGuide()"
      >
        {{ $t("button.assign") }}
      </button>
    </div>

    <!-- 情報 -->
    <div class="center tour-info">
      {{
        $t("pages.guides.selectguide.person", {
          currentGuideNum: guideschedules.filter((g) => g.checked).length,
          requiredNum: tour.guide_num,
        })
      }}
    </div>

    <!-- 参加ガイドの一覧 -->
    <h2>{{ $t("pages.tours.detail.guide_list_title") }}</h2>
    <div class="right">
      <input
        type="checkbox"
        id="check_send_email"
        name="check_send_email"
        :checked="send_email"
      />
      <label for="check_send_email">{{ $t("label.send_email") }}</label>
    </div>
    <GuidesTable
      :guides="guideschedules"
      :setting="{
        grayout: true,
        checkbox: true,
        assign: false,
        name: true,
        email: true,
        schedule: true,
        memo: true,
        error_msg: $t('table.no_data'),
      }"
    ></GuidesTable>
  </div>
</template>

<script>
import api from "@/mixins/api";
import table from "@/mixins/table";
import GuidesTable from "@/components/GuidesTable.vue";

export default {
  components: {
    GuidesTable,
  },
  data() {
    return {
      tour: {},
      guideschedules: [],
      tourguides: [],
      isChecking: 1,
      send_email: true,
    };
  },
  created() {},
  methods: {
    // 参加の有無によってチェックボックスの表示・非表示
    buttoncheck(state) {
      return state === 1 ? 1 : 2;
    },

    // ガイドへのリンク
    LinkGuide(id) {
      this.$router.push(`/accounts/guides/${id}`);
    },

    // チェックボックスを切り替える
    ChangeSelect(state, assign) {
      if (state !== 1) {
        return false;
      }

      return !assign;
    },

    // ガイドの数が予定通りなら色を変更
    guideNumError() {
      return {
        guideNumError:
          this.guideschedules.filter((g) => g.checked).length !==
          this.tour.guide_num,
      };
    },

    // 担当ガイドを送信
    async assignGuide() {
      // 予定の人数と違う
      if (
        this.guideschedules.filter((g) => g.checked).length !==
        this.tour.guide_num
      ) {
        if (!window.confirm("ガイドの人数が予定と違いますが、確定しますか？")) {
          window.alert("確定を取り消しました。");
          return;
        }
      }

      // 送信前の確認
      const email = document.getElementById("check_send_email");
      if (email.checked === true) {
        if (
          !window.confirm("担当が割り当てられたガイドへメールを送信します。")
        ) {
          window.alert("送信を取り消しました。");
          return;
        }
      } else if (email.checked === false) {
        if (
          !window.confirm(
            "担当が割り当てられたガイドへメールが送信されませんが、よろしいですか？"
          )
        ) {
          window.alert("送信を取り消しました。");
          return;
        }
      }

      // 送信メッセージの組み立て
      const guides = [];
      for (const g of this.guideschedules) {
        if (g === null || !g.checked) continue;
        guides.push(g.guide_id);
      }

      const object = {
        guides,
        send_mail: email.checked,
      };

      // 送信
      try {
        await api.post(
          `/api/v1/tours/${this.tour.id}/guides`,
          object,
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
    const response_achievements = await api.get(
      `/api/v1/tours/${to.params.id}/achievements`,
      next
    );

    // 各種情報のパース
    const { tour } = response.data;
    const guideschedules = response.data.guide_schedules;
    const tourguides = response.data.tour_guides;
    const { achievements } = response_achievements.data;

    // ネスとした情報を扱いやすいようにコピー
    for (const g of guideschedules) {
      g.name = g.guide.name;
      g.email = g.guide.email;
      g.state = guideStateMethod(g.answered, g.possible);
      g.checked = tourguides.some((u) => u.guide.id === g.guide.id);
      if (g.state !== 1) g.checked = false;
      g.id = `select-assign-${g.guide_id}`;
      g.memo = g.guide.memo;
      const temp = achievements.find((a) => a.guide_id === g.guide.id);
      g.achievement = temp !== undefined ? temp.last_tour : null;
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

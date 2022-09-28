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
          currentGuideNum: guideschedules.filter((g) => g.assign).length,
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
            class="memo"
          >
            <td
              @click="
                schedule.assign = ChangeSelect(schedule.state, schedule.assign)
              "
              class="center"
            >
              <input
                type="checkbox"
                class="checkbox-large"
                :id="schedule.id"
                name="select-assign"
                @click="
                  schedule.assign = ChangeSelect(
                    schedule.state,
                    schedule.assign
                  )
                "
                v-model="schedule.assign"
                v-if="isChecking === buttoncheck(schedule.state)"
              />
            </td>
            <td
              @click="
                schedule.assign = ChangeSelect(schedule.state, schedule.assign)
              "
            >
              {{ schedule.name }}
            </td>
            <td
              @click="
                schedule.assign = ChangeSelect(schedule.state, schedule.assign)
              "
            >
              {{ schedule.email }}
            </td>
            <td
              @click="
                schedule.assign = ChangeSelect(schedule.state, schedule.assign)
              "
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
            <div id="popup-memo" class="popup">
              <h4>{{ schedule.name }}</h4>
              <div id="memo-inner">
                <h5>
                  {{ $t("pages.tours.select_guides.popup_last_tour_title") }}
                  <span
                    v-if="schedule.achievement !== null"
                    class="memo-tour-state"
                    :class="addStateClass(tour.tour_state_code)"
                    >{{
                      codeToTourStateString(
                        schedule.achievement.tour_state_code
                      )
                    }}</span
                  >
                </h5>
                <div class="memo-info">
                  <small v-if="schedule.achievement !== null">
                    <div>
                      <a
                        @click="
                          $router.push(`/tours/${schedule.achievement.id}`)
                        "
                        href="javascript:void(0)"
                        >{{ schedule.achievement.name }}</a
                      >
                    </div>
                    <div>
                      {{ datetimeFormat(schedule.achievement.start_datetime) }}
                    </div>
                  </small>
                  <small v-else>{{
                    $t("pages.tours.select_guides.no_data")
                  }}</small>
                </div>
                <h5>{{ $t("pages.tours.select_guides.popup_memo_title") }}</h5>
                <div class="memo-info">
                  <small>{{ schedule.memo }}</small>
                </div>
              </div>
            </div>
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
      send_email: true,
    };
  },
  created() {},
  methods: {
    // 共通処理を受け渡し
    codeToTourStateString: (state) => common.codeToTourStateString(state),
    codeToGuideStateString: (state) => common.codeToGuideStateString(state),
    datetimeFormat: (d) => common.datetimeFormat(d),

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
      this.$router.push(`/accounts/guides/${id}`);
    },

    // チェックボックスを切り替える
    ChangeSelect(state, assign) {
      if (state !== 1) {
        return false;
      }

      return !assign;
    },

    // 担当割り当てができない場合はグレーアウト
    tableCSS(state) {
      return {
        grayout: state !== 1,
        "table-hover": state === 1,
      };
    },

    // ツアー状態によって色を付ける
    addStateClass(state) {
      return {
        CellState_1: state === 1,
        CellState_2: state === 2,
        CellState_32: state === 32,
        CellState_256: state === 256,
      };
    },

    // ガイドの数が予定通りなら色を変更
    guideNumError() {
      return {
        guideNumError:
          this.guideschedules.filter((g) => g.assign).length !==
          this.tour.guide_num,
      };
    },

    // 担当ガイドを送信
    async assignGuide() {
      // 予定の人数と違う
      if (
        this.guideschedules.filter((g) => g.assign).length !==
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
        if (g === null) continue;
        const elem = document.getElementById(g.id);
        if (elem === null || !elem.checked) continue;
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
      g.assign = tourguides.some((u) => u.guide.id === g.guide.id);
      if (g.state !== 1) g.assign = false;
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
.memo {
  position: relative;
}
.memo:hover .popup {
  display: block;
}

.popup {
  position: absolute;
  display: none;
  padding: 0.5em;
  margin-bottom: 12px;
  background-color: var(--color-white);
  border-radius: var(--default-radius);
  box-shadow: 5px 0 10px 5px rgba(0, 0, 0, 0.25);
  width: 16em;
  left: 20%;
  font-size: 100%;
  overflow: visible;
  z-index: 100;
  box-sizing: border-box;
}

#popup-memo h4 {
  padding: 0 0 0 0.5em;
  margin: 0 0 0.25em;
  border-bottom: 1px solid var(--color-dark-gray);
}

#popup-memo h5,
#popup-memo p {
  padding: 0;
  margin: 0;
}

#memo-inner {
  padding: 0.25em;
}

.memo-info {
  padding: 0 0.5em 0.5em;
}

/* ------------ 状態によって色を付ける ------------ */

.memo-tour-state {
  padding: 0 0.5em;
}

.CellState_1 {
  background-color: var(--color-tour-state-code-incomplete);
  color: var(--color-white);
}

.CellState_2 {
  background-color: var(--color-tour-state-code-assigned);
  color: var(--color-white);
}

.CellState_32 {
  background-color: var(--color-tour-state-code-complete);
  color: var(--color-white);
}

.CellState_256 {
  background-color: var(--color-tour-state-code-cancel);
  color: var(--color-white);
}
</style>

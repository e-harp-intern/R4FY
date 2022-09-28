<template>
  <div id="tour-page">
    <!-- ページタイトル -->
    <h1>{{ $t("pages.tours.detail.title") }}</h1>
    <div id="tour-name">{{ tour.name }}</div>

    <!-- 上部の情報パネル -->
    <div id="panel">
      <article class="tour_info" id="guide">
        <p class="outline">
          {{ $t("pages.tours.detail.requirement_guide_num_title") }}
        </p>
        <p class="value">
          {{ $t("common.people_num_unit", { num: tour.guide_num }) }}
        </p>
      </article>
      <article class="tour_info" id="date">
        <p class="outline">{{ $t("common.start_datetime") }}</p>
        <p class="value">{{ datetimeFormat(tour.start_datetime) }}</p>
      </article>
      <article
        class="tour_info state"
        id="state"
        :class="changeToTourStateColor(tour.tour_state_code)"
      >
        <p class="outline">{{ $t("pages.tours.detail.tour_state_title") }}</p>
        <p class="value">{{ codeToTourStateString(tour.tour_state_code) }}</p>
      </article>
    </div>

    <!-- 参加者情報・メモ情報 -->
    <div id="grid">
      <div id="num">
        <table class="inline_table">
          <caption>
            {{
              $t("pages.tours.detail.tour_participant_num.caption")
            }}
          </caption>
          <tr>
            <td>
              {{ $t("pages.tours.detail.tour_participant_num.adult_num") }}
            </td>
            <td>
              {{ $t("common.people_num_unit", { num: tour.adult_num }) }}
            </td>
          </tr>
          <tr>
            <td>
              {{ $t("pages.tours.detail.tour_participant_num.child_num") }}
            </td>
            <td>
              {{ $t("common.people_num_unit", { num: tour.child_num }) }}
            </td>
          </tr>
          <tr>
            <td>{{ $t("pages.tours.detail.tour_participant_num.sum_num") }}</td>
            <td>
              {{
                $t("common.people_num_unit", {
                  num: tour.adult_num + tour.child_num,
                })
              }}
            </td>
          </tr>
        </table>
      </div>
      <div class="memo">
        <p id="memo">{{ $t("common.tour_memo") }}</p>
        <div class="memo_box">
          {{ tour.memo }}
        </div>
      </div>
    </div>

    <!-- 詳細情報 -->
    <h2>{{ $t("pages.tours.detail.detail_title") }}</h2>
    <div>
      <ul>
        <li>
          {{ $t("label.start_datetime") }}
          {{ datetimeFormat(tour.start_datetime) }}
        </li>
        <li>
          {{ $t("label.end_datetime") }} {{ datetimeFormat(tour.end_datetime) }}
        </li>
        <li>
          {{ $t("label.schedule_input_deadline") }}
          <span v-if="tour.schedule_input_deadline !== null">{{
            datetimeFormat(tour.schedule_input_deadline)
          }}</span>
          <span v-else>{{ $t("common.not_set") }}</span>
        </li>
        <li>
          {{ $t("label.send_remind") }} -
          <span v-if="tour.send_remind">{{ $t("common.yes") }}</span>
          <span v-else>{{ $t("common.no") }}</span>
        </li>
      </ul>
    </div>

    <!-- ツアー操作 -->
    <h2>{{ $t("pages.tours.detail.tour_setting_title") }}</h2>
    <div id="settings-frame">
      <span v-for="setting in settings" :key="setting.text">
        <button
          v-if="setting.fn_disp()"
          @click="setting.fn_click()"
          href="javascript:void(0)"
          :class="setting.css"
        >
          {{ setting.text }}
        </button>
      </span>
    </div>
    <div
      class="center"
      v-if="
        !isShow_Delete() &&
        !isShow_AssignGuide() &&
        !isShow_EditTour() &&
        !isShow_CompleteTour()
      "
    >
      {{ $t("pages.tours.detail.nothing_to_operate") }}
    </div>

    <!-- 担当ガイド一覧 -->
    <h2>{{ $t("pages.tours.detail.assign_guide_list_title") }}</h2>
    <table class="table-normal">
      <thead>
        <tr>
          <th @click="sortBy('name')" :class="addSortClass('name')">
            {{ $t("table.guide.name") }}
          </th>
          <th @click="sortBy('email')" :class="addSortClass('email')">
            {{ $t("table.guide.email") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="guide in tourguides"
          :key="guide.id"
          class="table-hover"
          @click="LinkGuide(guide.guide_id)"
        >
          <td>{{ guide.name }}</td>
          <td>{{ guide.email }}</td>
        </tr>
      </tbody>
    </table>
    <div class="center" v-if="tourguides.length === 0">
      {{ $t("pages.tours.detail.assign_guide_list_error") }}
    </div>

    <!-- 参加ガイドの一覧 -->
    <h2>{{ $t("pages.tours.detail.guide_list_title") }}</h2>
    <div>
      <!-- 操作ボタン -->
      <div id="button-frame">
        <button
          @click="guideScheduleSet(guideschedules, true)"
          class="button-large"
          :class="{ 'button-green': isGuideSelect(guideschedules) }"
        >
          {{ $t("button.set_guide_participation") }}
        </button>
        <button
          @click="guideScheduleSet(guideschedules, false)"
          class="button-large"
          :class="{ 'button-red': isGuideSelect(guideschedules) }"
        >
          {{ $t("button.set_guide_non_participation") }}
        </button>
        <button
          @click="sendGuideScheduleEmail(guideschedules)"
          class="button-large"
          :class="{ 'button-green': isGuideSelect(guideschedules) }"
        >
          {{ $t("button.re_send_schedule_input_email") }}
        </button>
      </div>

      <!-- 参加ガイドの一覧テーブル -->
      <table class="table-normal">
        <thead>
          <tr>
            <th
              @click="sortBy('checked')"
              :class="addSortClass('checked')"
            ></th>
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
            v-for="schedule in guideschedules"
            :key="schedule.id"
            class="table-hover"
          >
            <td class="center" @click="schedule.checked = !schedule.checked">
              <input
                type="checkbox"
                class="checkbox-large"
                v-model="schedule.checked"
              />
            </td>
            <td @click="LinkGuide(schedule.guide_id)" class="center">
              <span v-if="schedule.assign">{{
                $t("table.guide.assign_mark")
              }}</span>
            </td>
            <td @click="LinkGuide(schedule.guide_id)">{{ schedule.name }}</td>
            <td @click="LinkGuide(schedule.guide_id)">{{ schedule.email }}</td>
            <td @click="LinkGuide(schedule.guide_id)" class="center">
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
import constant from "@/mixins/constant";

export default {
  data() {
    return {
      tour: {},
      guideschedules: [],
      tourguides: [],
      fn_guide_array: () => {},
      fn_assign_array: () => {},
      settings: [],
    };
  },
  created() {
    // 設定項目の追加（担当ガイド選択）
    this.settings.push({
      text: this.$t("pages.tours.detail.settings_select_guides"),
      fn_disp: this.isShow_AssignGuide,
      fn_click: this.goTourSelectGuide,
      css: "button-green",
    });

    // 設定項目の追加（ツアー編集）
    this.settings.push({
      text: this.$t("pages.tours.detail.settings_edit"),
      fn_disp: this.isShow_EditTour,
      fn_click: this.goTourChange,
      css: "button-green",
    });

    // 設定項目の追加（実施済みへ）
    this.settings.push({
      text: this.$t("pages.tours.detail.settings_complete"),
      fn_disp: this.isShow_CompleteTour,
      fn_click: this.tourComplete,
      css: "button-blue",
    });

    // 設定項目の追加（中止）
    this.settings.push({
      text: this.$t("pages.tours.detail.settings_delete"),
      fn_disp: this.isShow_Delete,
      fn_click: this.alert_disp,
      css: "button-red",
    });
  },
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

    // 中止操作表示条件
    isShow_Delete() {
      return [
        constant.TOUR_STATE.TOUR_STATE_CODE_INCOMPLETE,
        constant.TOUR_STATE.TOUR_STATE_CODE_ASSIGNED,
        constant.TOUR_STATE.TOUR_STATE_CODE_COMPLETE,
      ].includes(this.tour.tour_state_code);
    },

    // 担当決定表示条件
    isShow_AssignGuide() {
      return [
        constant.TOUR_STATE.TOUR_STATE_CODE_INCOMPLETE,
        constant.TOUR_STATE.TOUR_STATE_CODE_ASSIGNED,
      ].includes(this.tour.tour_state_code);
    },

    // ツアー編集表示条件
    isShow_EditTour() {
      return [
        constant.TOUR_STATE.TOUR_STATE_CODE_INCOMPLETE,
        constant.TOUR_STATE.TOUR_STATE_CODE_ASSIGNED,
        constant.TOUR_STATE.TOUR_STATE_CODE_COMPLETE,
      ].includes(this.tour.tour_state_code);
    },

    // ツアー実施済み変更条件
    isShow_CompleteTour() {
      return [
        constant.TOUR_STATE.TOUR_STATE_CODE_INCOMPLETE,
        constant.TOUR_STATE.TOUR_STATE_CODE_ASSIGNED,
      ].includes(this.tour.tour_state_code);
    },

    // テーブル内にチェックボックス選択済みのガイドがいるか
    isGuideSelect(list) {
      return list.reduce((p, c) => (p === true ? true : c.checked), false);
    },

    // チェック済みのガイドのスケジュールを強制的に変更する
    async guideScheduleSet(list, flg) {
      // 選択済みのガイドがいない場合
      if (!this.isGuideSelect(list)) {
        alert(this.$t("pages.tours.detail.alert_no_guide_select"));
        return;
      }

      // 警告ダイアログ
      if (
        !window.confirm(
          this.$t("pages.tours.detail.alert_guide_schedule_change")
        )
      ) {
        alert(this.$t("common.alert.operation_aborted"));
        return;
      }

      // リクエスト本体
      try {
        // ロード中にする
        this.$emit("SendLoadComplete", false);

        // リクエストを組み立て
        const request = [];
        for (const guide of list) {
          if (!guide.checked) continue;
          const url = `/api/v1/tours/${this.tour.id}/guides/${guide.guide_id}/schedules`;
          request.push(api.patch(url, { possible: flg }, this.$router.push));
        }

        // リクエストを送信
        await Promise.all(request);

        // ツアー情報を再取得
        await this.reacquisitionTourDetail();
      } catch {
        // エラー発生時
        alert(this.$t("alert.common.on_error"));
        this.$router.go({ path: this.$router.currentRoute.path, force: true });
      } finally {
        this.$emit("SendLoadComplete", true);
      }
    },

    // ガイドへ予定入力依頼を再送する
    async sendGuideScheduleEmail(list) {
      // 選択済みのガイドがいない場合
      if (!this.isGuideSelect(list)) {
        alert(this.$t("pages.tours.detail.alert_no_guide_select"));
        return;
      }

      // 警告ダイアログ
      if (
        !window.confirm(
          this.$t("pages.tours.detail.alert_guide_schedule_email_send")
        )
      ) {
        alert(this.$t("common.alert.operation_aborted"));
        return;
      }

      try {
        // ロード中にする
        this.$emit("SendLoadComplete", false);

        // リクエストを組み立て
        const url = `/api/v1/tours/${this.tour.id}/schedules/mail`;
        const guides = [];
        for (const guide of list) {
          if (!guide.checked) continue;
          guides.push(guide.guide_id);
        }

        // リクエストを送信
        const response = await api.post(url, { guides }, this.$router.push);
        if (response.status !== constant.STATE.SUCCESS)
          throw new Error("api error");

        // ツアー情報を再取得
        await this.reacquisitionTourDetail();
      } catch {
        // エラー発生時
        alert(this.$t("alert.common.on_error"));
        this.$router.go({ path: this.$router.currentRoute.path, force: true });
      } finally {
        this.$emit("SendLoadComplete", true);
      }
    },

    // ツアー情報を再セット
    async reacquisitionTourDetail() {
      // リクエストを組み立て
      const response = await api.get(
        `/api/v1/tours/${this.tour.id}`,
        null,
        this.$router.push
      );

      // ツアー情報を再セット
      this.guideschedules = this.fn_guide_array(response.data.guide_schedules);
      this.tourguides = this.fn_assign_array(response.data.tour_guides);
    },

    // ガイドへのリンク
    LinkGuide(id) {
      this.$router.push(`/accounts/guides/${id}`);
    },

    // ツアー中止処理
    async alert_disp() {
      if (window.confirm(this.$t("pages.tours.detail.alert1"))) {
        // 「OK」時の処理終了
        await api.delete(`/api/v1/tours/${this.tour.id}`);
        window.alert(this.$t("pages.tours.detail.alert2"));
        this.$router.go({ path: this.$router.currentRoute.path, force: true }); // リロードする
      } else {
        // 「キャンセル」時の処理開始
        window.alert(this.$t("pages.tours.detail.alert3")); // 警告ダイアログを表示
      }
    },

    // ツアー担当ガイドを選択、決定するページへ遷移する
    goTourSelectGuide() {
      this.$router.push(`/tours/${this.tour.id}/selectguide`);
    },

    // ツアー詳細を変更する画面へ遷移
    goTourChange() {
      this.$router.push(`/tours/${this.tour.id}/edit`);
    },

    // ツアー完了処理
    async tourComplete() {
      if (!window.confirm(this.$t("pages.tours.detail.alert_complete"))) {
        window.alert(this.$t("common.alert.operation_aborted"));
        return;
      }
      await api.post(`/api/v1/tours/${this.tour.id}/complete`);
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },

    // ツアー状態によって背景色を変更(idを置き換える)
    changeToTourStateColor(code) {
      return {
        state1: code === 1,
        state2: code === 2,
        state32: code === 32,
        state256: code === 256,
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
    const response = await api.get(`/api/v1/tours/${to.params.id}`, null, next);

    // 取得エラーでエラーページへ
    if (response.status !== constant.STATE.SUCCESS) {
      next(`/error`);
      return;
    }

    // 各種情報のパース
    const { tour } = response.data;
    let { guide_schedules, tour_guides } = response.data;

    // 情報を扱いやすい形に変更する関数
    const fn_guide_array = (list) => {
      for (const g of list) {
        g.name = g.guide.name;
        g.email = g.guide.email;
        g.state = guideStateMethod(g.answered, g.possible);
        g.assign = tour_guides.some((u) => u.guide.id === g.guide.id);
        g.checked = false;
      }
      return list;
    };

    // 情報を扱いやすい形に変更（担当者）する関数
    const fn_assign_array = (list) => {
      for (const g of list) {
        g.name = g.guide.name;
        g.email = g.guide.email;
        g.assign = tour_guides.some((u) => u.guide.id === g.guide.id);
      }
      return list;
    };

    // 情報を変換
    guide_schedules = fn_guide_array(guide_schedules);
    tour_guides = fn_assign_array(tour_guides);

    // 画面へ情報を渡す
    next((vm) => {
      vm.tour = tour;
      vm.guideschedules = guide_schedules;
      vm.tourguides = tour_guides;
      vm.fn_guide_array = fn_guide_array;
      vm.fn_assign_array = fn_assign_array;
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";

#button-frame {
  display: flex;
  padding: 1em;
  box-sizing: border-box;
  justify-content: start;
}

#tour-name {
  font-size: 3em;
  text-align: center;
  margin: 0;
}

h2 {
  margin: 50px 0 0 0;
}

#grid {
  padding-top: 50px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: auto;
}

.tour_info {
  display: inline-block;
  width: 100%;
  color: var(--color-white);
  text-align: center;
  vertical-align: middle;
  padding: 0.5em 0;
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
.state {
  background-color: var(--color-tour-state-code-cancel);
}
.state1 {
  background-color: var(--color-tour-state-code-incomplete);
}
.state2 {
  background-color: var(--color-tour-state-code-assigned);
}
.state32 {
  background-color: var(--color-tour-state-code-complete);
}
.state256 {
  background-color: var(--color-tour-state-code-cancel);
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
#memo {
  text-align: center;
  font-size: 1.25em;
  margin: 0;
}
#panel {
  clear: both;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}

.memo_box {
  margin: 0;
  min-width: 50%;
  min-height: 80%;
  background-color: var(--color-light-gray);
  border: solid 3px var(--color-theme);
  padding: 1em;
  box-sizing: border-box;
}

.checkbox-large {
  transform: scale(1.5);
}

#settings-frame {
  display: flex;
  padding: 1em;
  box-sizing: border-box;
  justify-content: start;
}
</style>

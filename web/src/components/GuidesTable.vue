<template>
  <div>
    <table class="table-normal">
      <thead>
        <tr>
          <th
            v-if="setting.checkbox"
            @click="sortBy('checked')"
            :class="addSortClass('checked')"
          ></th>
          <th
            v-if="setting.assign"
            @click="sortBy('assign')"
            :class="addSortClass('assign')"
          >
            {{ $t("table.guide.assign") }}
          </th>
          <th
            v-if="setting.name"
            @click="sortBy('name')"
            :class="addSortClass('name')"
          >
            {{ $t("table.guide.name") }}
          </th>
          <th
            v-if="setting.email"
            @click="sortBy('email')"
            :class="addSortClass('email')"
          >
            {{ $t("table.guide.email") }}
          </th>
          <th
            v-if="setting.schedule"
            @click="sortBy('state')"
            :class="addSortClass('state')"
          >
            {{ $t("table.guide.answered_state") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="guide in guides"
          :key="guide.id"
          :class="tableCSS(guide.state)"
          class="memo"
        >
          <td
            v-if="setting.checkbox"
            class="center"
            @click="checkChange(guide)"
          >
            <input
              v-if="
                setting.checkbox &&
                (!setting.grayout || guide.checked || guide.state === 1)
              "
              type="checkbox"
              class="checkbox-large"
              v-model="guide.checked"
            />
          </td>
          <td v-if="setting.assign" class="center">
            <span v-if="guide.assign">{{ $t("table.guide.assign_mark") }}</span>
          </td>
          <td v-if="setting.name">
            <a @click="LinkGuide(guide.guide_id)" href="javascript:void(0)">
              {{ guide.name }}
            </a>
          </td>
          <td v-if="setting.email">{{ guide.email }}</td>
          <td v-if="setting.schedule" class="center">
            {{ codeToGuideStateString(guide.state) }}
          </td>
          <div v-if="setting.memo" id="popup-memo" class="popup">
            <h4>{{ guide.name }}</h4>
            <div id="memo-inner">
              <h5>
                {{ $t("pages.tours.select_guides.popup_last_tour_title") }}
                <span
                  v-if="guide.achievement !== null"
                  class="memo-tour-state"
                  :class="addStateClass(guide.achievement.tour_state_code)"
                >
                  {{ codeToTourStateString(guide.achievement.tour_state_code) }}
                </span>
              </h5>
              <div class="memo-info">
                <small v-if="guide.achievement !== null">
                  <div>
                    <a
                      @click="$router.push(`/tours/${guide.achievement.id}`)"
                      href="javascript:void(0)"
                      >{{ guide.achievement.name }}</a
                    >
                  </div>
                  <div>
                    {{ datetimeFormat(guide.achievement.start_datetime) }}
                  </div>
                </small>
                <small v-else>{{
                  $t("pages.tours.select_guides.no_data")
                }}</small>
              </div>
              <h5>{{ $t("pages.tours.select_guides.popup_memo_title") }}</h5>
              <div class="memo-info">
                <small>{{ guide.memo }}</small>
              </div>
            </div>
          </div>
        </tr>
      </tbody>
    </table>

    <!-- 表示データがないとき -->
    <div v-if="guides.length === 0" class="center">
      {{ setting.error_msg }}
    </div>
  </div>
</template>

<script>
import table from "@/mixins/table";
import common from "@/mixins/common";

export default {
  props: ["guides", "setting"],
  methods: {
    codeToTourStateString: (state) => common.codeToTourStateString(state),
    codeToGuideStateString: (state) => common.codeToGuideStateString(state),
    datetimeFormat: (d) => common.datetimeFormat(d),

    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.guides);
    },

    // ガイドへのリンク
    LinkGuide(id) {
      this.$router.push(`/accounts/guides/${id}`);
    },

    // 担当割り当てができない場合はグレーアウト
    tableCSS(state) {
      return {
        grayout: this.isGrayout(state),
        "table-hover": !this.isGrayout(state),
      };
    },

    // グレーアウトするかの判定
    isGrayout(state) {
      return state !== 1 && this.setting.grayout;
    },

    // チェックボックスの処理
    checkChange(guide) {
      if (this.isGrayout(guide.state)) {
        return;
      }

      guide.checked = !guide.checked;
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
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";

// メモ関連
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

.memo-tour-state {
  padding: 0 0.5em;
}

/* ------------ 状態によって色を付ける ------------ */

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

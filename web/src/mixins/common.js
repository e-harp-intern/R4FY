/* eslint-disable */
// 共通処理

import Vue from 'vue';

/* ツアー状態文字の定義 */
const tourStateString = {
    1: Vue.i18n.t("state.tour.1"),
    2: Vue.i18n.t("state.tour.2"),
    32: Vue.i18n.t("state.tour.32"),
    256: Vue.i18n.t("state.tour.256"),
}

/* 参加可否状態の文字の定義 */
const guideStateString = {
    1: Vue.i18n.t("state.guide_participation.1"),
    2: Vue.i18n.t("state.guide_participation.2"),
    3: Vue.i18n.t("state.guide_participation.3"),
}

/* 日本時間をUTCへ変換（タイムゾーン情報を削除） */
const datetimeUTC = (datetime) => {
    datetime = String(datetime)
    datetime = datetime.split("Z")[0];
    datetime = datetime.split("GMT+")[0];
    datetime = new Date(datetime);
    return new Date(Date.UTC(datetime.getFullYear(), datetime.getMonth(), datetime.getDate(), datetime.getHours(), datetime.getMinutes()))
}

const methods = {
    /* ツアー状態をコードから文字列にする */
    codeToTourStateString(state) {
        return tourStateString[state];
    },

    /* ガイド参加可否入力状態をコードから文字列に変換 */
    codeToGuideStateString(code) {
        return guideStateString[code];
    },

    /* 日付フォーマット */
    datetimeFormat: (datetime) => {
        return Vue.i18n.t("common.datetime", methods.datetimeData(datetime));
    },

    /* 日時成形処理用パーツ */
    datetimeData: (datetime) => {
        datetime = datetimeUTC(datetime);
        return {
            year: datetime.getUTCFullYear(),
            month: (datetime.getUTCMonth() + 1).toString().padStart(2, "0"),
            date: datetime.getUTCDate().toString().padStart(2, "0"),
            hours: datetime.getUTCHours().toString().padStart(2, "0"),
            minutes: datetime.getUTCMinutes().toString().padStart(2, "0"),
        };
    },

    /* タイムゾーンを削除（文字列 → 日時） */
    datetimeUTC: (datetime) => datetimeUTC(datetime),
}

export default methods;

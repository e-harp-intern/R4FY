/* eslint-disable */

import Vue from "vue";
import VueI18n from "vue-i18n";
import messages from "./messages";

Vue.use(VueI18n);

const i18n = new VueI18n({
    locale: "ja",
    messages,
});

Vue.i18n = i18n;

export default i18n;

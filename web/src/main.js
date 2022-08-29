import Vue from "vue";
import App from "@/App.vue";
import router from "@/router";
import session from "@/mixins/session";
import i18n from "@/i18n";

Vue.config.productionTip = false;
Vue.mixin(session);

new Vue({
  router,
  i18n,
  render: (h) => h(App),
}).$mount("#app");

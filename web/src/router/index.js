import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "login",
    component: () => import("@/views/LoginView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/tourslist",
    name: "tourslist",
    component: () => import("@/views/ToursListView.vue"),
  },
  {
    path: "/tour",
    name: "tour",
    component: () => import("@/views/TourView.vue"),
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;

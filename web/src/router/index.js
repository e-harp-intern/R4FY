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
    path: "/accounts/create",
    name: "createaccount",
    component: () => import("@/views/accounts/CreateAccountView.vue"),
  },
  {
    path: "/tours",
    name: "tourslist",
    component: () => import("@/views/ToursListView.vue"),
  },
  {
    path: "/tours/create",
    name: "input",
    component: () => import("@/views/tours/CreateTourView.vue"),
  },
  {
    path: "/tours/:id",
    name: "tour",
    component: () => import("@/views/tours/TourDetailView.vue"),
  },
  {
    path: "/tours/:id/selectguide",
    name: "tour",
    component: () => import("@/views/tours/SelectGuidesView.vue"),
  },
  {
    path: "/guides/:token/schedules",
    name: "inputschedule",
    component: () => import("@/views/guide/InputScheduleView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/accounts",
    name: "accounts",
    component: () => import("@/views/AccountsListView.vue"),
  },
  {
    path: "/accounts/guides/:id",
    name: "guide_detail",
    component: () => import("@/views/accounts/GuideDetailView.vue"),
  },
  {
    path: "/logout",
    name: "logout",
    component: () => import("@/views/LogoutView.vue"),
  },
  {
    path: "/error",
    name: "error",
    component: () => import("@/views/ErrorView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/*",
    name: "notfound",
    component: () => import("@/views/NotFoundView.vue"),
    meta: {
      layout: "simple",
    },
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;

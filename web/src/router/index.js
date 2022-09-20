import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "LoginView",
    component: () => import("@/views/LoginView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/accounts/create",
    name: "CreateAccountView",
    component: () => import("@/views/accounts/CreateAccountView.vue"),
  },
  {
    path: "/tours",
    name: "ToursListView",
    component: () => import("@/views/ToursListView.vue"),
  },
  {
    path: "/tours/create",
    name: "CreateTourView",
    component: () => import("@/views/tours/CreateTourView.vue"),
  },
  {
    path: "/tours/:id",
    name: "TourDetailView",
    component: () => import("@/views/tours/TourDetailView.vue"),
  },
  {
    path: "/tours/:id/selectguide",
    name: "SelectGuidesView",
    component: () => import("@/views/tours/SelectGuidesView.vue"),
  },
  {
    path: "/guides/:token/schedules",
    name: "InputScheduleView",
    component: () => import("@/views/guide/InputScheduleView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/myaccount",
    name: "MyAccountView",
    component: () => import("@/views/accounts/MyAccountView.vue"),
  },
  {
    path: "/myaccount/:id/change",
    name: "ChangeMyaccountInfoView",
    component: () => import("@/views/accounts/ChangeMyaccountInfoView.vue"),
  },
  {
    path: "/accounts",
    name: "AccountsListView",
    component: () => import("@/views/AccountsListView.vue"),
  },
  {
    path: "/accounts/guides/:id",
    name: "GuideDetailView",
    component: () => import("@/views/accounts/GuideDetailView.vue"),
  },
  {
    path: "/logout",
    name: "LogoutView",
    component: () => import("@/views/LogoutView.vue"),
  },
  {
    path: "/reset/:token",
    name: "PasswordResetView",
    component: () => import("@/views/PasswordResetView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/error",
    name: "ErrorView",
    component: () => import("@/views/ErrorView.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/*",
    name: "NotFoundView",
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

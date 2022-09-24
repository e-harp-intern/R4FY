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
    path: "/tours/:id/edit",
    name: "EditTourView",
    component: () => import("@/views/tours/EditTourView.vue"),
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
    path: "/myaccount/",
    name: "MyAccountView",
    component: () => import("@/views/accounts/MyAccountView.vue"),
  },
  {
    path: "/myaccount/:id/editmyaccount",
    name: "EditMyaccountInfoView",
    component: () => import("@/views/accounts/EditMyaccountInfoView.vue"),
  },
  {
    path: "/myaccount/:id/editpassword",
    name: "EditPasswordView",
    component: () => import("@/views/accounts/EditPasswordView.vue"),
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
    path: "/accounts/guides/:id/edit",
    name: "EditGuideInfoView",
    component: () => import("@/views/accounts/EditGuideInfoView.vue"),
  },
  {
    path: "/accounts/admins/:id",
    name: "AdminDetailView",
    component: () => import("@/views/accounts/AdminDetailView.vue"),
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

// スクロール位置の制御
const scrollBehavior = (to, from, savedPosition) => {
  if (savedPosition) return savedPosition;
  return { x: 0, y: 0 };
};

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
  scrollBehavior,
});

export default router;

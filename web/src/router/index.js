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
    component: () => import("@/views/CreateAccount.vue"),
  },
  {
    path: "/tours",
    name: "tourslist",
    component: () => import("@/views/ToursListView.vue"),
  },
  {
    path: "/tours/create",
    name: "input",
    component: () => import("@/views/CreateTour.vue"),
  },
  {
    path: "/tours/:id",
    name: "tour",
    component: () => import("@/views/TourView.vue"),
  },
  {
    path: "/guide/input_schedule/:token",
    name: "inputschedule",
    component: () => import("@/views/guide/InputSchedule.vue"),
    meta: {
      layout: "simple",
    },
  },
  {
    path: "/accounts",
    name: "accounts",
    component: () => import("@/views/AccountView.vue"),
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;

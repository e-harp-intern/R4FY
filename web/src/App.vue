<template>
  <div id="app">
    <component
      v-bind:is="layout()"
      v-bind:class="{ 'event-none': loading }"
      @LoadComplete="LoadComplete"
    ></component>
    <LoadingTemplate v-show="loading"></LoadingTemplate>
  </div>
</template>

<style>
@import "@/assets/css/color.css";
@import "@/assets/css/style.css";
</style>

<style scoped>
#app {
  position: relative;
}

.event-none {
  pointer-events: none;
}
</style>

<script>
// ロードのパーツ
import LoadingTemplate from "@/components/LoadingTemplate";

// レイアウトコンポーネントをインポート
import DefaultLayout from "./components/layout/DefaultLayout.vue";
import NoneLayout from "./components/layout/NoneLayout.vue";
import SimpleLayout from "./components/layout/SimpleLayout.vue";

export default {
  data() {
    return { loading: true };
  },
  components: {
    LoadingTemplate,
    DefaultLayout,
    NoneLayout,
    SimpleLayout,
  },
  methods: {
    layout() {
      const layout = this.$route.meta.layout
        ? `${this.$route.meta.layout}-layout`
        : "default-layout";
      return layout;
    },
    LoadComplete(flg) {
      this.loading = !flg;
    },
  },
};
</script>

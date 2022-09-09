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
      const layoutName = this.$route.meta.layout;
      const layout = layoutName ? `${layoutName}-layout` : "default-layout";
      return this.$route.name ? layout : "none-layout";
    },
    LoadComplete(flg) {
      this.loading = !flg;
    },
  },
};
</script>

<template>
  <div id="login-layout">
    <div>
      <PageHeader></PageHeader>
      <router-view @SendLoadComplete="LoadComplete"></router-view>
    </div>
    <PageFooter></PageFooter>
  </div>
</template>

<style scoped>
#login-layout {
  text-align: center;

  display: grid;
  grid-template-rows: 1fr auto;
  min-height: 100vh;
}
</style>

<script>
import PageHeader from "@/components/PageHeader.vue";
import PageFooter from "@/components/PageFooter.vue";

export default {
  components: {
    PageHeader,
    PageFooter,
  },
  created() {
    // ローディング解除
    this.$emit("LoadComplete", true);
  },
  methods: {
    LoadComplete(flg) {
      this.$emit("LoadComplete", flg);
    },
  },
};
</script>

<template>
  <div id="default-layout">
    <div id="app">
      <SideMenu @SendLoadComplete="SendLoadComplete"></SideMenu>
      <div id="main">
        <div id="contents">
          <div>
            <PageHeader></PageHeader>
          </div>
          <div id="main-contents">
            <div>
              <router-view
                v-bind:class="{ 'event-none': loading }"
                id="app-view"
                @SendLoadComplete="SendLoadComplete"
              ></router-view>
            </div>
            <PageFooter></PageFooter>
          </div>
        </div>
        <LoadingTemplate v-if="loading"></LoadingTemplate>
      </div>
    </div>
  </div>
</template>

<script>
import LoadingTemplate from "@/components/LoadingTemplate";
import PageFooter from "@/components/PageFooter.vue";
import SideMenu from "@/components/SideMenu.vue";
import PageHeader from "@/components/PageHeader.vue";

export default {
  name: "DefaultLayout",
  components: {
    PageFooter,
    LoadingTemplate,
    SideMenu,
    PageHeader,
  },
  created() {
    this.$emit("LoadComplete", true); // ローディング解除
  },
  data() {
    return {
      number: 0,
      loading: false,
      nextPath: "",
    };
  },
  methods: {
    test() {
      this.number += 3;
    },
    SendLoadComplete(flg) {
      this.loading = !flg;
    },
  },
};
</script>

<style lang="scss" scoped>
#default-layout {
  #app {
    display: grid;
    grid-template-columns: auto 1fr;
    min-height: 100vh;
    padding: 0;
  }

  #app-view {
    padding: 1em 4em;
    box-sizing: border-box;
  }

  .event-none {
    pointer-events: none;
  }

  #contents {
    position: relative;
    height: 100%;
    display: grid;
    grid-template-rows: auto 1fr;
  }

  #main-contents {
    position: relative;
    display: grid;
    grid-template-rows: 1fr auto;
  }

  #main {
    position: relative;
    max-width: 100%;
  }
}
</style>

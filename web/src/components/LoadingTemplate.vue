<template>
  <div id="loading">
    <div class="fullview">
      <div class="loading-spacer"></div>
      <vue-loading
        type="spiningDubbles"
        color="#fff"
        :size="{ width: '100px', height: '100px' }"
      >
      </vue-loading>
    </div>
  </div>
</template>

<script>
import { VueLoading } from "vue-loading-template";

export default {
  name: "LoadingTemplate",
  components: {
    VueLoading,
  },
};
</script>

<style scoped>
#loading {
  box-sizing: border-box;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  position: absolute;
}
.fullview {
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  position: sticky;
  box-sizing: border-box;
}
.loading-spacer {
  height: 100px;
  box-sizing: border-box;
}
</style>

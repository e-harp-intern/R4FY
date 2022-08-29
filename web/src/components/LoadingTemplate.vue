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
  z-index: 9999;
}
.fullview {
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  position: absolute;
}
.loading-spacer {
  height: 30%;
}
</style>

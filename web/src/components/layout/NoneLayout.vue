<template>
  <div><router-view @LoadComplete="LoadComplete"></router-view></div>
</template>

<script>
export default {
  created() {
    this.$emit("LoadComplete", true); // ローディング解除
  },
  methods: {
    LoadComplete(flg) {
      this.$emit("LoadComplete", flg); // ローディング解除
    },
  },
};
</script>

<template>
  <div>
    <h1>{{ $t("pages.help.title") }}</h1>
    <p>{{ $t("pages.help.what") }}</p>

    <hr />

    <h2>{{ $t("pages.help.subtitle1") }}</h2>
    <p>{{ $t("pages.help.how_create_accounts") }}</p>
    <h3>{{ $t("pages.help.subtitle2") }}</h3>
    <p>{{ $t("pages.help.how_create_guide") }}</p>
    <h3>{{ $t("pages.help.subtitle3") }}</h3>
    <p>{{ $t("pages.help.how_create_admin") }}</p>

    <hr />

    <h2>{{ $t("pages.help.subtitle4") }}</h2>
    <p>{{ $t("pages.help.how_create_tour") }}</p>

    <hr />

    <h2>{{ $t("pages.help.subtitle_tour_state") }}</h2>
    <p>{{ $t("pages.help.tour_state_info") }}</p>

    <hr />

    <h2>{{ $t("pages.help.subtitle_guide_achievement") }}</h2>
    <p>{{ $t("pages.help.guide_achievement_info") }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  methods: {},
};
</script>
<style></style>

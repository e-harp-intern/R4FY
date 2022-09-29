<template>
  <div>
    <!-- 担当ガイド一覧 -->
    <h2>{{ $t("pages.tours.detail.assign_guide_list_title") }}</h2>
    <GuidesTable
      :guides="tourguides"
      :setting="{
        grayout: false,
        checkbox: false,
        assign: false,
        name: true,
        email: true,
        schedule: false,
        memo: false,
        error_msg: $t('pages.tours.detail.assign_guide_list_error'),
      }"
    ></GuidesTable>
  </div>
</template>

<script>
import GuidesTable from "@/components/GuidesTable.vue";

export default {
  components: {
    GuidesTable,
  },
  props: ["tourguides"],
};
</script>

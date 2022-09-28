<template>
  <div>
    <!-- 担当ガイド一覧 -->
    <h2>{{ $t("pages.tours.detail.assign_guide_list_title") }}</h2>
    <table class="table-normal">
      <thead>
        <tr>
          <th @click="sortBy('name')" :class="addSortClass('name')">
            {{ $t("table.guide.name") }}
          </th>
          <th @click="sortBy('email')" :class="addSortClass('email')">
            {{ $t("table.guide.email") }}
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="guide in tourguides"
          :key="guide.id"
          class="table-hover"
          @click="LinkGuide(guide.guide_id)"
        >
          <td>{{ guide.name }}</td>
          <td>{{ guide.email }}</td>
        </tr>
      </tbody>
    </table>
    <div class="center" v-if="tourguides.length === 0">
      {{ $t("pages.tours.detail.assign_guide_list_error") }}
    </div>
  </div>
</template>

<script>
import table from "@/mixins/table";

export default {
  created() {},
  props: ["tourguides"],
  methods: {
    // テーブル処理を共通メソッドに渡す
    addSortClass: (key) => table.methods.addSortClass(key),
    sortBy(key) {
      table.methods.sortBy(key, this.tourguides);
    },
    // ガイドへのリンク
    LinkGuide(id) {
      this.$router.push(`/accounts/guides/${id}`);
    },
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";
</style>

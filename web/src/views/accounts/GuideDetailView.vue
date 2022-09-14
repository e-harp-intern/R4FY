<!-- ガイドの詳細ページ -->
<template>
  <div>
    <h1>{{ $t("pages.accounts.guides.title") }}</h1>

    <!-- 操作 -->
    <ul>
      <li>
        <a href="javascript:void(0)">{{
          $t("pages.accounts.guides.link_guide_edit")
        }}</a>
      </li>
    </ul>

    <!-- ガイドの情報 -->
    <h2>{{ guide.name }}</h2>
    <ul>
      <li>
        {{ $t("label.email") }}
        <a :href="'mailto:' + guide.email">{{ guide.email }}</a>
      </li>
      <li>{{ $t("label.memo") }} {{ guide.memo }}</li>
    </ul>

    <!-- 実績情報 -->
    <h2>{{ $t("pages.accounts.guides.title_achievement") }}</h2>

    <!-- 最後に参加したツアー -->
    <h3>{{ $t("pages.accounts.guides.title_last_tour") }}</h3>
    <ul v-if="last_tour.name !== undefined">
      <li>
        {{ $t("label.tour_name") }}
        <a :href="'/tours/' + last_tour.id">{{ last_tour.name }}</a>
      </li>
      <li>
        {{ $t("label.start_datetime") }}
        {{ datetimeFormat(last_tour.start_datetime) }}
      </li>
      <li>
        {{ $t("label.end_datetime") }}
        {{ datetimeFormat(last_tour.end_datetime) }}
      </li>
    </ul>
    <div v-else class="center">
      {{ $t("pages.accounts.guides.no_last_tour") }}
    </div>

    <!-- 過去のツアー -->
    <h3>{{ $t("pages.accounts.guides.title_participation_tours") }}</h3>
    <table class="table-normal">
      <thead>
        <tr>
          <th>{{ $t("table.tour.name") }}</th>
          <th>{{ $t("table.tour.start_datetime") }}</th>
          <th>{{ $t("table.tour.end_datetime") }}</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="participation_tour in participation_tours"
          :key="participation_tour.id"
        >
          <td>{{ participation_tour.name }}</td>
          <td>{{ datetimeFormat(participation_tour.start_datetime) }}</td>
          <td>{{ datetimeFormat(participation_tour.end_datetime) }}</td>
        </tr>
      </tbody>
    </table>
    <div v-if="participation_tours.length === 0" class="center">
      {{ $t("pages.accounts.guides.no_participation_tours") }}
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";

export default {
  data() {
    return {
      guide: {},
      achievement: {},
      last_tour: {},
      participation_tours: [],
    };
  },
  methods: {
    datetimeFormat: (d) => common.datetimeFormat(d),
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(
      `/api/v1/guides/${to.params.id}`,
      null,
      next
    );

    next((vm) => {
      vm.guide = response.data.guide;
      vm.achievement = response.data.achievement;
      vm.last_tour = response.data.achievement.last_tour || {};
      vm.participation_tours =
        response.data.achievement.participation_tours || [];
    });
  },
};
</script>

<style lang="scss" scoped>
@import "@/assets/css/table.scss";
</style>
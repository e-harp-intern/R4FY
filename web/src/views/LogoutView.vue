<template>
  <p>{{ $t("pages.logout.info") }}</p>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {};
  },
  async created() {
    try {
      const response = await api.delete("/api/v1/logout");
      if (response.status === "error") throw new Error("api error");
      this.$router.push("/");
    } catch {
      alert(this.$t("pages.logout.alert"));
    }
  },
};
</script>

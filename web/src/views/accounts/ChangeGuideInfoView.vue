<template>
  <div id="change-guideinfo-page">
    <h1>{{ $t("pages.guides.change_guideinfo.title") }}</h1>
    <div class="form-frame">
      <div class="form-main">
        <div class="form-tabel">
          <label>{{ $t("label.name") }}</label
          ><input
            type="text"
            placeholder="name"
            id="name"
            v-bind:value="guide.name"
          />
          <label>{{ $t("label.email") }}</label
          ><input
            type="text"
            placeholder="email"
            id="email"
            v-bind:value="guide.email"
          />
          <label>{{ $t("label.memo") }}</label
          ><textarea
            cols="30"
            rows="5"
            name="memo"
            id="memo"
            v-bind:value="guide.memo"
          >
          </textarea>
        </div>
        <br />
        <div class="form-button-frame">
          <button class="" @click="$router.back()">
            {{ $t("button.cancel") }}
          </button>
          <button type="submit" @click="change()" class="button-green">
            {{ $t("button.change") }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      is_invalid: false,
      guide: {},
    };
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  methods: {
    async change() {
      const object = {
        name: document.getElementById("name").value,
        email: document.getElementById("email").value,
        memo: document.getElementById("memo").value,
      };

      // ロード中にする
      this.$emit("SendLoadComplete", false);

      // アカウント作成情報を送信
      const response = await api.patch(
        `/api/v1/guides/${this.$route.params.id}`,
        object,
        this.$router.push
      );

      // API完了
      if (response.status === "success") {
        // 成功
        alert(this.$t("pages.guides.change_guideinfo.alert1"));
        const path = `/accounts/guides/${this.$route.params.id}`;
        this.$router.push(path);
      } else {
        // 失敗
        this.$router.push("?status=500").catch(() => {});
      }

      this.$emit("SendLoadComplete", true);
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(
      `/api/v1/guides/${to.params.id}`,
      null,
      next
    );

    next((vm) => {
      vm.is_invalid = !(response.status === "success");
      vm.guide = response.data.guide;
    });
  },
};
</script>

<style scoped>
.change-guideinfo-page {
  max-width: 100%;
  position: relative;
}

.form-frame {
  margin: 0 auto;
  width: 100%;
  max-width: 640px;
  background-color: var(--color-light-gray);
  box-sizing: border-box;
  border-radius: 0.5em;
}

.form-tabel {
  width: 80%;
  display: inline-grid;
  grid-template-columns: auto 1fr;
  grid-row-gap: 0.5em;
}

.form-tabel label {
  height: 100%;
  display: flex;
  justify-content: right;
  align-items: center;
}

.form-main {
  padding: 2em;
}

.form-button-frame {
  padding: 2em 2em 0;
  display: flex;
  justify-content: right;
  align-items: center;
}
</style>

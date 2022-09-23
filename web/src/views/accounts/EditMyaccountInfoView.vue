<template>
  <div id="change-account-page">
    <h1>{{ $t("pages.myaccount.edit.title") }}</h1>
    <div class="form-frame">
      <div class="form-main">
        <div class="form-tabel">
          <label>{{ $t("label.name") }}</label
          ><input
            type="text"
            placeholder="name"
            id="name"
            v-bind:value="admin.name"
          />
          <label>{{ $t("label.email") }}</label
          ><input
            type="text"
            placeholder="email"
            id="email"
            v-bind:value="admin.email"
          />
        </div>
        <br />
        <div class="form-button-frame">
          <button class="" @click="$router.back()">
            {{ $t("button.cancel") }}
          </button>
          <button type="submit" @click="edit()" class="button-green">
            {{ $t("button.edit") }}
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
      admin: {},
    };
  },
  created() {
    this.$emit("SendLoadComplete", true); // ロード完了をアニメーションに伝える
  },
  methods: {
    async edit() {
      const object = {
        name: document.getElementById("name").value,
        email: document.getElementById("email").value,
      };
      // ロード中にする
      this.$emit("SendLoadComplete", false);

      // マイアカウント情報変更内容を送信
      const response = await api.patch(
        `/api/v1/admins/${this.$route.params.id}`,
        object,
        this.$router.push
      );

      // API完了
      if (response.status === "success") {
        // 成功
        alert(this.$t("pages.myaccount.edit.message_true"));
        this.$router.push("/myaccount");
      } else {
        // 失敗
        this.$router.push("?status=500").catch(() => {});
      }

      this.$emit("SendLoadComplete", true);
    },
  },
  async beforeRouteEnter(to, from, next) {
    const response = await api.get(`/api/v1/admins/me`, null, next);
    // 各種情報のパース
    const { admin } = response.data;
    next((vm) => {
      vm.admin = admin;
    });
  },
};
</script>

<style scoped>
.change-account-page {
  max-width: 100%;
  position: relative;
}

.change-info {
  background-color: var(--color-light-gray);
  border-radius: 1em;
  text-align: center;
  padding: 2em;
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

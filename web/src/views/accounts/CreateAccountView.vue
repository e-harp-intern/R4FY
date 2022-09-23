<template>
  <div id="create-account-page">
    <p class="create-info" v-if="$route.query.status == '200'">
      {{ $t("pages.accounts.create.message.true") }}
    </p>
    <p class="create-info" v-if="$route.query.status == '500'">
      {{ $t("pages.accounts.create.message.false") }}
    </p>
    <h1>{{ $t("pages.accounts.create.title") }}</h1>
    <p>
      {{ $t("pages.accounts.create.detail") }}
    </p>
    <div class="form-frame">
      <form @submit.prevent="create" class="form-main">
        <div id="radio">
          <input
            id="admin_radio"
            type="radio"
            name="class"
            value="admin"
            v-model="isAdminChecking"
          /><label for="admin_radio">{{ $t("account.admin") }}</label>
          <input
            type="radio"
            name="class"
            value="guide"
            id="guide_radio"
            v-model="isAdminChecking"
          /><label for="guide_radio">{{ $t("account.guide") }}</label>
        </div>
        <div class="form-tabel">
          <label for="name">{{ $t("label.name") }}</label
          ><input type="text" placeholder="name" id="name" />
          <label for="email">{{ $t("label.email") }}</label
          ><input type="text" placeholder="email" id="email" />
          <label for="memo" v-if="isAdminChecking === 'guide'">{{
            $t("label.memo")
          }}</label
          ><textarea
            cols="30"
            rows="5"
            name="memo"
            id="memo"
            v-if="isAdminChecking === 'guide'"
          >
          </textarea>
        </div>
        <br />
        <div class="form-button-frame">
          <button class="" @click="$router.back()">
            {{ $t("button.cancel") }}
          </button>
          <button type="submit" class="button-green">
            {{ $t("button.send") }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";

export default {
  data() {
    return {
      test: "",
      isAdminChecking: "admin",
    };
  },
  created() {},
  methods: {
    form_reset() {
      const forms = document.getElementsByTagName("input");
      for (let i = 0; i < forms.length; i += 1) {
        forms[i].value = null;
      }
    },
    async create() {
      let classpath = "/api/v1/admins";
      const object = {
        name: document.getElementById("name").value,
        email: document.getElementById("email").value,
      };
      if (
        document.querySelector("input[name=class]:checked").value === "guide"
      ) {
        classpath = "/api/v1/guides";
        object.memo = document.getElementById("memo").value;
        // object = 'memo: document.getElementById("memo").value,';
        // alert(object);
      }
      try {
        // ロード中にする
        this.$emit("SendLoadComplete", false);

        // アカウント作成情報を送信
        const response = await api.post(classpath, object, this.$router.push);

        // API完了
        if (response.status === "success") {
          // 成功
          alert(this.$t("pages.accounts.create.message.true"));
          this.$router.push("/accounts");
        } else {
          // 失敗
          this.$router.push("?status=500").catch(() => {});
        }
        /* } else {
          const response = await api.post(
            "/api/v1/admins",
            {
              name: document.getElementById("name").value,
              email: document.getElementById("email").value,
            },
            this.$router.push
          );

          // API完了
          if (response.status === "success") {
            // 成功
            this.form_reset();
            this.$router.push("/tourslist");
          } else {
            // 失敗
            this.$router.push("?status=500").catch(() => {});
          }
        } */
      } catch {
        this.error = 500;
      } finally {
        this.$emit("SendLoadComplete", true);
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.create-account-page {
  max-width: 100%;
  position: relative;
}

.create-info {
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
#radio {
  display: flex;
  justify-content: center;
  margin-bottom: 1em;
}
#guide_radio {
  margin-left: 2em;
}
</style>

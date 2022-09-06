<template>
  <div>
    <div class="form-frame" v-if="isInput === 'false'">
      <form @submit.prevent="create" class="form-main">
        <div id="radio">
          <input
            type="radio"
            name="class"
            value="participate"
            id="participate"
          />
          <label for="participate"
            >{{ $t("pages.inputschedule.participate") }}
          </label>
          <br />
          <input type="radio" name="class" value="absent" id="absent" /><label
            for="absent"
            >{{ $t("pages.inputschedule.absent") }}
          </label>
        </div>
        <br />
        <div class="form-button-frame">
          <button type="submit" class="button-green">
            {{ $t("button.send") }}
          </button>
        </div>
      </form>
    </div>
    <div>
      <p v-if="isInput === 'true'">{{ $t("pages.inputschedule.send") }}</p>
    </div>
  </div>
</template>

<script>
// import api from "@/mixins/api";

export default {
  data() {
    return {
      url: "",
      isInput: "false",
      guidetoken: "",
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
      // const classpath = "APIのpath";

      // 現在のURL(Path)からガイドのトークンを取得
      this.url = this.$route.path;
      this.guidetoken = this.url.substring(this.url.lastIndexOf("/") + 1);
      alert(this.guidetoken);
      const object = {
        token: this.guidetoken,
      };
      // 参加できる：1
      // 参加できない：-1
      if (
        document.querySelector("input[name=class]:checked").value ===
        "participate"
      ) {
        object.schedule = "true";
      } else if (
        document.querySelector("input[name=class]:checked").value === "absent"
      ) {
        object.schedule = "false";
      }
      // チェックボックスの値を取得出来ているかの確認
      alert(document.querySelector("input[name=class]:checked").value);

      // try {
      //   // ロード中にする
      //   this.$emit("SendLoadComplete", false);

      //   // アカウント作成情報を送信
      //   const response = await api.post(classpath, object, this.$router.push);

      //   // API完了
      //   if (response.status === "success") {
      //     // 成功
      //     this.isInput = "true";
      //     this.form_reset();
      //     this.$router.push("/InputSchedule");
      //   } else {
      //     // 失敗
      //     this.$router.push("?status=500").catch(() => {});
      //   }
      // } catch {
      //   this.error = 500;
      // } finally {
      //   this.$emit("SendLoadComplete", true);
      // }
      this.isInput = "true";
    },
  },
};
</script>

<style lang="scss" scoped></style>

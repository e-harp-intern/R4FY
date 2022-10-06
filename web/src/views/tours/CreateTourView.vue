<template>
  <div id="create-account-page">
    <h1>{{ $t("pages.tours.create.title") }}</h1>
    <div id="page-frame">
      <div class="form-frame">
        <form @submit.prevent="create" class="form-main">
          <div class="form-tabel">
            <!--ツアー名-->
            <label>{{ $t("label.tour_name") }}</label
            ><input type="text" id="tour_name" required />
            <!--開始日時-->
            <label>{{ $t("label.start_datetime") }}</label
            ><input
              type="datetime-local"
              id="start_datetime"
              :value="defaultTime()"
              required
            />
            <!--終了日時-->
            <label>{{ $t("label.end_datetime") }}</label
            ><input
              type="datetime-local"
              id="end_datetime"
              :value="defaultTime()"
              required
            />
            <!--大人-->
            <label>{{ $t("label.adult_num") }}</label
            ><input type="number" id="adult_num" />
            <!--子供-->
            <label>{{ $t("label.child_num") }}</label
            ><input type="number" id="child_num" />
            <!--ガイド-->
            <label>{{ $t("label.guide_num") }}</label
            ><input type="number" id="guide_num" />
            <!--参加可否入力期限-->
            <label>{{ $t("label.schedule_input_deadline") }}</label
            ><input type="date" id="schedule_input_deadline" />
            <!--メモ-->
            <label>{{ $t("label.tour_memo") }}</label
            ><textarea cols="30" rows="5" name="memo" id="memo"> </textarea>
          </div>
          <hr />
          <!-- 選択項目 -->
          <ul class="plain_list">
            <li>
              <input type="checkbox" id="send_remind" checked /><label
                for="send_remind"
                >{{ $t("label.send_remind") }}</label
              >
            </li>
            <li>
              <input type="checkbox" id="send_mail" checked /><label
                for="send_mail"
                >{{ $t("label.send_email") }}</label
              >
            </li>
          </ul>
          <div class="form-button-frame">
            <button type="submit" class="button-green">
              {{ $t("button.send") }}
            </button>
          </div>
        </form>
      </div>

      <!-- 説明 -->
      <div class="info" id="create-info-frame">
        <h2>{{ $t("pages.tours.create.title_info") }}</h2>
        <p>{{ $t("pages.help.how_create_tour") }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import api from "@/mixins/api";
import common from "@/mixins/common";

export default {
  data() {
    return {
      test: "",
    };
  },
  created() {},
  methods: {
    // フォームの初期時間（現在時の00分を返す）
    defaultTime() {
      const date = new Date(Date.now());
      date.setMinutes(0);
      date.setSeconds(0);
      return this.$t("system.datetime", common.datetimeData(date));
    },

    // フォームをリセット
    form_reset() {
      const forms = document.getElementsByTagName("input");
      for (let i = 0; i < forms.length; i += 1) {
        forms[i].value = null;
      }
    },
    async create() {
      // 期限未入力
      if (document.getElementById("schedule_input_deadline").value === "") {
        if (
          !window.confirm(
            this.$t("pages.tours.create.alert_schedule_input_deadline")
          )
        ) {
          window.alert(this.$t("common.cancel"));
          return;
        }
      }

      // 現在の時刻を取得
      const date = new Date(Date.now());
      // 開始日時が過去になっているか確認
      if (new Date(document.getElementById("start_datetime").value) < date) {
        if (!window.confirm(this.$t("pages.tours.create.alert_start_date"))) {
          window.alert(this.$t("common.cancel"));
          return;
        }
      }

      // API
      try {
        // ロード中にする
        this.$emit("SendLoadComplete", false);
        // アカウント作成情報を送信
        const response = await api.post(
          "/api/v1/tours",
          {
            name: document.getElementById("tour_name").value,
            start_datetime: document.getElementById("start_datetime").value,
            end_datetime: document.getElementById("end_datetime").value,
            adult_num: document.getElementById("adult_num").value,
            child_num: document.getElementById("child_num").value,
            guide_num: document.getElementById("guide_num").value,
            schedule_input_deadline: document.getElementById(
              "schedule_input_deadline"
            ).value,
            send_remind: document.getElementById("send_remind").checked,
            send_mail: document.getElementById("send_mail").checked,
            memo: document.getElementById("memo").value,
          },
          this.$router.push
        );
        // API完了
        if (response.status === "success") {
          // 成功
          this.form_reset();
          this.$router.push(`/tours/${response.data.tour.id}`);
        } else {
          // 失敗
          alert(this.$t("pages.tours.create.create_api_error"));
        }
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
#page-frame {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  justify-content: center;
  gap: 2em;
}

#page-frame > div {
  margin: 0 0;
}

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
  width: 640px;
  max-width: 100%;
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

#create-info-frame {
  padding: 2em;
  box-sizing: border-box;
  line-height: 1.75em;
}

.plain_list {
  list-style: none;
  margin-left: 0;
  padding-left: 0;
}
</style>

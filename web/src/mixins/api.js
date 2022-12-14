/*
 Web API接続用モジュールです。
 使用するファイル内で読み込んでください。
 > import api from "@/mixins/api";
*/

// eslint-disable-next-line no-restricted-globals
const APIServerPass = process.env.VUE_APP_API_ORIGIN; // APIサーバーの場所を指定

// apiSend ...データの送信を行なう
function apiSend(method, endPoint, json = null, next = null) {
  return new Promise((resolve) => {
    fetch(APIServerPass + endPoint, {
      method,
      mode: "cors",
      credentials: "include",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: json === null ? null : JSON.stringify(json),
    })
      .then((response) => {
        if (response.status === 401) {
          next("/?status=401");
        }
        resolve(response.json());
      })
      .catch(() => {
        next("/error");
      });
  });
}

// 送信用メソッド（必ず next を設定）
export default {
  async get(endPoint, json = {}, next = null) {
    if (json !== null && json !== {}) {
      let add = "";
      const keys = Object.keys(json);
      for (const key of keys) {
        if (key === null) continue;
        if (Array.isArray(json[key])) {
          add += `&${key}[]=${json[key].join(`&${key}[]=`)}`;
          delete json[key];
        }
      }
      endPoint = `${endPoint}?${new URLSearchParams(json)}${add}`;
    }
    return apiSend("GET", endPoint, null, next);
  },
  async post(endPoint, json = {}, next = null) {
    return apiSend("POST", endPoint, json, next);
  },
  async patch(endPoint, json = {}, next = null) {
    return apiSend("PATCH", endPoint, json, next);
  },
  async delete(endPoint, json = null, next = null) {
    return apiSend("DELETE", endPoint, json, next);
  },
};

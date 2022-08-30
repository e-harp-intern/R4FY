/* eslint-disable */

export default {
    pages: {
        login: {
            title: "ログインページ",
            error: {
                status_401: "メールアドレスまたはパスワードが違います。",
                status_500: "エラーが発生しました。"
            }
        },
        createaccount: {
            title: "アカウント作成",
           detail:  "以下のフォームに情報を入力してください。送信ボタンを押すと、アカウント作成通知メールが、入力したメールアドレス宛に送信されます。",
           message: {
            true:"アカウントを作成しました。",
            false:"アカウントの作成に失敗しました。"
           }
        }
    },
    other: {
        fotter: "license. MIT"
    },
    button: {
        login: "ログイン",
        send: "送信",
        password_reset: "パスワードの再発行"
    },
    placeholder: {
        email: "email",
        password: "password"
    },
    label: {
        name: "名前：",
        email: "メールアドレス：",
        password: "パスワード：",
        memo: "メモ：",
    },
    account: {
        manager: "管理者",
        guide: "ガイド"
    }
};

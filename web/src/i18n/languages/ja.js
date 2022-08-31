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
        tours: {
            title: "ツアー",
            tour: {
                title: "ツアー詳細",
            }
        },
        {
        createaccount: {
            title: "アカウント作成",
           detail:  "以下のフォームに情報を入力してください。送信ボタンを押すと、アカウント作成通知メールが、入力したメールアドレス宛に送信されます。",
           message: {
            true:"アカウントを作成しました。",
            false:"アカウントの作成に失敗しました。"
           }
        },
    },
    other: {
        fotter: "license. MIT",
        datetime: "%{year}年%{month}月%{date}日 %{hours}時%{minutes}分",
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
    table: {
        tour:{
            name:"ツアー名",
            start_datetime:"開始日時",
            end_datetime:"終了日時",
            state:"状態"
        }
    },
    state: {
        tour: {
            1: "未実施(担当ガイド未決定)",
            2: "担当者決定済み",
            4: "実施済み",
            5: "実績記入済み",
            8: "中止",
        }
    },
    account: {
        manager: "管理者",
        guide: "ガイド"
    }
};

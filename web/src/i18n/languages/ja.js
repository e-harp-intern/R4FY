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
    },
    other: {
        fotter: "license. MIT",
        datetime: "%{year}年%{month}月%{date}日 %{hours}時%{minutes}分",
    },
    button: {
        login: "ログイン",
        password_reset: "パスワードの再発行"
    },
    placeholder: {
        email: "email",
        password: "password"
    },
    label: {
        email: "メールアドレス：",
        password: "パスワード："
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
    }
};

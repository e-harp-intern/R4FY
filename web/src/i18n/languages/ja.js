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
                tour_state_title: "ツアー実施状態",
                requirement_guide_num_title: "必要ガイド人数",
                guide_list_title: "参加予定一覧",
                tour_setting_title: "ツアー操作"
            },
            create: {
                title: "ツアー新規追加",
            },
            delete: {
                title: "ツアー取り消し",
            },
            select: {
                title: "担当ガイド選択画面へ",
            },
            admin_name_show: {
                welcome_message: "%{admin_name}さん、こんにちは！"
            }
        },
        createaccount: {
            title: "アカウント作成",
            detail: "以下のフォームに情報を入力してください。送信ボタンを押すと、アカウント作成通知メールが、入力したメールアドレス宛に送信されます。",
            message: {
                true: "アカウントを作成しました。",
                false: "アカウントの作成に失敗しました。"
            }
        },
        accounts: {
            title: "アカウント"
        }
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
        tour_name: "ツアー名：",
        start_datetime: "開始日時：",
        end_datetime: "終了日時：",
        adult_num: "大人人数：",
        child_num: "子供人数：",
        guide_num: "ガイド人数：",
        schedule_input_deadline: "参加可否入力期限：",
        remind_date: "リマインド日：",
        detail: {
            tour_name: "ツアーの名前を入力してください",
            adult_num: "人数を入力してください",
            child_num: "いない場合「0」を入力してください",
            guide_num: "必ず人数を入力してください",
        }
    },
    table: {
        tour_participant_num: {
            caption: "ツアー参加者人数",
            adult_num: "大人",
            child_num: "子供",
            sum_num: "合計"
        },
        tour: {
            name: "ツアー名",
            start_datetime: "開始日時",
            end_datetime: "終了日時",
            state: "状態"
        },
        guide: {
            assign: "担当",
            name: "名前",
            email: "メールアドレス",
            answered_state: "参加可否",
            assign_mark: "〇"
        },
        account: {
            authority: "権限",
            name: "名前",
            email: "メールアドレス",
        }
    },
    state: {
        tour: {
            1: "未実施(担当ガイド未決定)",
            2: "担当者決定済み",
            4: "実施済み",
            8: "実績記入済み",
            256: "中止",
        },
        guide_participation: {
            1: "〇",
            2: "×",
            3: "未入力",
        }
    },
    account: {
        admin: "管理者",
        guide: "ガイド"
    },
    common: {
        memo: "メモ",
        start_datetime: "開始日時",
        end_datetime: "終了日時",
        people_num_unit: "%{num} 名"
    },
};

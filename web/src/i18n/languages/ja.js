/* eslint-disable */

export default {
    app_name: "観光地ガイドスケジュール調整システム",
    pages: {
        login: {
            title: "ログインページ",
            title_reset: "パスワードのリセット",
            error: {
                status_401: "メールアドレスまたはパスワードが違います。",
                status_500: "エラーが発生しました。"
            },
            alert_reset_mail_error: "再設定メールの送信に失敗しました。もう一度お試しください。",
            alert_reset_mail: "再設定メールを送信しました。",
            info_title: "注意事項",
            info: "・フォームに登録されたアカウントのメールアドレスとパスワードを入力してください。\n・ログインするためにはアカウントが必要です。アカウントの作成は管理者のみが行なうことができます。\n・詳細は管理者までお問い合わせください。",
            reset_info: "・フォームにメールアドレスを入力し、ボタンを押してください。\n・登録されたメールアドレスに、パスワード再設定用のメールを送信したします。"
        },
        tours: {
            title: "ツアー",
            title_search: "詳細検索",
            no_data_error: "表示するデータがありません。検索条件を指定、もしくはツアーの新規追加をしてください。",
            tour: {
                title: "ツアー詳細",
                tour_state_title: "ツアー実施状態",
                requirement_guide_num_title: "必要ガイド人数",
                guide_list_title: "参加予定一覧",
                tour_setting_title: "ツアー操作",
                alert1: "ツアーの取り消しを実行しますか？",
                alert2: "ツアーの中止を行いました。",
                alert3: "キャンセルされました",
                alert4: "担当ガイドの取り消しを実行しますか？",
                alert5: "担当ガイドの取り消しを行いました。",
                alert6: "担当ガイド取り消しを中止しました。"
            },
            create: {
                title: "ツアー追加",
                create_api_error: "エラーが発生しました。日付等を確認してもう一度お試しください。",
                alert_schedule_input_deadline: "予定入力期限が設定されていません。担当が確定するまで予定の入力をすることができますが、よろしいですか？",
                alert_remind_date: "リマインドの日付が設定されていませんが、よろしいですか？"
            },
            delete: {
                title: "ツアー取り消し",
                guide: "担当ガイド取り消し",
            },
            select: {
                title: "担当ガイド選択画面へ",
            },
            admin_name_show: {
                welcome_message: "%{admin_name}さん、こんにちは！"
            }
        },
        createaccount: {
            title: "アカウント追加",
            detail: "以下のフォームに情報を入力してください。送信ボタンを押すと、アカウント作成通知メールが、入力したメールアドレス宛に送信されます。",
            message: {
                true: "アカウントを作成しました。",
                false: "アカウントの作成に失敗しました。"
            }
        },
        inputschedule: {
            participate: "参加できる",
            absent: "参加できない",
            send: "送信完了"
        },
        accounts: {
            title: "アカウント",
            link_alert: "エラーが発生しました。",
            guides: {
                title: "ガイド詳細情報",
                title_achievement: "実績情報",
                title_last_tour: "最後に参加したツアー",
                no_last_tour: "ツアー未参加です。",
                title_participation_tours: "過去5回のツアー情報",
                no_tours: "取得できるツアー情報が存在しませんでした。",
                link_guide_edit: "ガイド情報を編集する",
                title_assign_tours: "担当割り当て済みのツアー",
                is_invalid: "削除済みのユーザーもしくは、データの取得に失敗しました。",
                link_accounts_list: "一覧画面へ戻る"
            }
        },
        myaccount: {
            title: "マイアカウント情報",

        },
        guides: {
            schedules: {
                info: "ツアーでの担当ガイドのスケジュール調整のため、参加できるか・できないかの入力をお願いいたします。"
                , error: "エラーが発生しました。時間を置いてもう一度お試しください。",
                button_absent: "参加できない",
                button_participate: "参加できる",
                alert_no_input: "参加できるかできないかを選択してください。"
            },
            selectguide: {
                title: "ツアー担当ガイド決定画面",
                person: "人",
                person2: "人/",
            },
            delete_guide:{
                alert: "ガイドを削除しますか？",
                alert1: "ガイドを削除しました。",
                alert2: "削除を中止しました。"
            }
        },
        password_reset: {
            title: "パスワードの再設定",
            alert_password: "入力されたパスワードが違います。",
            alert_api: "エラーが発生しました。もう一度お試しください。",
            alert_ok: "パスワードを再設定しました。ログイン画面からログインしてください。"
        },
        password_change:{
            title: "パスワード変更",
            alert_password: "入力されたパスワードが違います。",
            alert_api: "エラーが発生しました。もう一度お試しください。",
            alert_ok: "パスワードを再設定しました。ログイン画面からログインしてください。"
        },
        logout: {
            title: "ログアウト",
            info: "ログアウト中です...",
            alert: "ログアウトに失敗しました。"
        },
        notfound: {
            title: "お探しのページは見つかりませんでした。",
            info: "404 NotFound\n\n申し訳ございません。\n指定されたファイルまたはディレクトリは存在いたしません。",
            link: "ログインページへ戻る"
        },
        error: {
            title: "エラーが発生しました。",
            info: "500 ServerError\n\n申し訳ございません。\nサーバーエラーが発生しました。\n時間をおいてもう一度お試しください。",
            link: "ログインページへ戻る"
        }
    },
    other: {
        fotter: "license. MIT",
        datetime: "%{year}年%{month}月%{date}日 %{hours}時%{minutes}分",
    },
    button: {
        login: "ログイン",
        send: "送信",
        password_change: "パスワードの変更",
        cancel: "キャンセル",
        account_create: "＋アカウント作成",
        tour_create: "＋ツアー作成",
        send_mail: "メールを送信",
        submit: "確定",
        searchbar: "詳細検索",
        search: "検索",
        assign: "担当者を確定する",
        change: "変更",
        delete_guide: "ガイド削除",
    },
    placeholder: {
        email: "email",
        password: "password",
        password_reenter: "password"
    },
    label: {
        name: "名前：",
        email: "メールアドレス：",
        password: "パスワード：",
        password_reenter: "パスワード（再入力）：",
        memo: "メモ：",
        tour_name: "ツアー名：",
        start_datetime: "開始日時：",
        end_datetime: "終了日時：",
        adult_num: "大人人数：",
        child_num: "子供人数：",
        max_num: "最大人数：",
        guide_num: "ガイド人数：",
        schedule_input_deadline: "参加可否入力期限：",
        remind_date: "リマインド日：",
        detail: {
            tour_name: "ツアーの名前を入力してください",
            adult_num: "人数を入力してください",
            child_num: "いない場合「0」を入力してください",
            guide_num: "必ず人数を入力してください",
        },
        time_to: "～",
        send_info: "送信内容："
    },
    table: {
        tour_participant_num: {
            caption: "ツアー参加者人数",
            adult_num: "大人",
            child_num: "子供",
            sum_num: "合計"
        },
        tour: {
            id: "ID",
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
            assign_mark: "〇",
            link: "ガイド情報"
        },
        account: {
            authority: "権限",
            name: "名前",
            email: "メールアドレス",
        }
    },
    state: {
        tour: {
            1: "未実施（担当ガイド未決定）",
            2: "担当者決定済み",
            4: "実施済み（実績未記入）",
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
        people_num_unit: "%{num} 名",
        date_start_end: "%{start} ~ %{end}",
        name: "%{name} 様",
        router_back: "前のページへ戻る",
        cancel: "取り消しました。",
        check: "確認"
    },
    system: {
        datetime: "%{year}-%{month}-%{date} %{hours}:%{minutes}"
    }
};

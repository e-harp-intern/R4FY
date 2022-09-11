# 実績関連の共通処理です
module Achievement
  include Common
  extend ActiveSupport::Concern

  # 指定したIDのガイドの実績を取得する
  def achievement(guide_id, month = 3, tour_num = 5)
    # 初期値
    achievement = {}
    today = Date.today

    # 前回出席ツアーを検索
    achievement["lasttime"] = TourGuide
                              .where(guide_id: guide_id, achievements_entered: true) # 指定ガイドの入力済み実績のみ取得
                              .joins(:tour) # ツアーを結合
                              .select("tours.*") # ツアー情報のみを取得
                              .where.not("tour_state_code = ?", TOUR_STATE_CODE_CANCEL) # 中止ツアーを除く
                              .order(start_datetime: "DESC") # 開始日順に並び替え（可能なら最大値を使用）
                              .first # 先頭の開始日のみ取得

    # 最新 tour_num 回 の出席したツアーのリストを取得
    achievement["participation_days"] = TourGuide
                                        .where(guide_id: guide_id, achievements_entered: true)
                                        .joins(:tour)
                                        .select("tours.*")
                                        .where.not("tour_state_code = ?", TOUR_STATE_CODE_CANCEL)
                                        .order(start_datetime: "DESC")
                                        .limit(tour_num)

    # 過去（今日から指定月前） month 月 に出席したツアーの回数を取得
    achievement["participation_num"] = TourGuide
                                       .where(guide_id: guide_id, achievements_entered: true)
                                       .joins(:tour)
                                       .select("tours.*")
                                       .where.not("tour_state_code = ?", TOUR_STATE_CODE_CANCEL)
                                       .where("start_datetime <= ?", today)
                                       .where("start_datetime > ?", today.ago(month.month))
                                       .count(:id)

    # 参加予定のツアーのリスト（今日以降）
    achievement["assign"] = TourGuide
                            .where(guide_id: guide_id)
                            .joins(:tour)
                            .select("tours.*")
                            .where("start_datetime > ?", today)
                            .where("tour_state_code = ?", TOUR_STATE_CODE_ASSIGNED) # 担当者割り当て済みのみから取得

    # 返すデータ
    achievement
  end
end

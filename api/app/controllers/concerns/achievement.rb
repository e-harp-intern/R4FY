# 実績関連の共通処理です
module Achievement
  include Common
  extend ActiveSupport::Concern

  # 指定したIDのガイドの実績を取得する
  def achievement(guide_id, tour_num = 100)
    # 初期値
    achievement = {}
    today = Date.today

    # ガイド情報を追加
    achievement["guide_id"] = guide_id

    # 前回出席ツアーを検索
    achievement["last_tour"] = TourGuide
                               .where(guide_id: guide_id) # 指定ガイドのみ取得
                               .joins(:tour) # ツアーを結合
                               .select("tours.*") # ツアー情報のみを取得
                               .where("tour_state_code = ?", TOUR_STATE_CODE_COMPLETE)
                               .order(start_datetime: "DESC") # 開始日順に並び替え（可能なら最大値を使用）
                               .first # 先頭の開始日のみ取得

    # 最新 tour_num 回 の担当したツアーのリストを取得 （過去日 or 実施済み設定）
    achievement["participation_tours"] = TourGuide
                                         .where(guide_id: guide_id)
                                         .joins(:tour)
                                         .select("tours.*")
                                         #.where.not("tour_state_code = ?", TOUR_STATE_CODE_CANCEL)
                                         .where("start_datetime < ? or tour_state_code = ?", today, TOUR_STATE_CODE_COMPLETE)
                                         .order(start_datetime: "DESC")
                                         .limit(tour_num)

    # 参加予定のツアーのリスト（今日以降）
    achievement["assign_tours"] = TourGuide
                                  .where(guide_id: guide_id)
                                  .joins(:tour)
                                  .select("tours.*")
                                  .where("start_datetime >= ?", today)
                                  .where("tour_state_code = ?", TOUR_STATE_CODE_ASSIGNED) # 担当者割り当て済みのみから取得

    # 返すデータ
    achievement
  end
end

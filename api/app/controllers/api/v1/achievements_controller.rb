# 実績を入力するためのコントローラー
class Api::V1::AchievementsController < ApplicationController
  before_action :require_login

  # 実績を入力
  def create
    # createですが、updateで保存しています
    tour_id = params[:tour_id]
    guide_id = params[:guide_id]
    achievements = TourGuide.find_by(tour_id: tour_id, guide_id: guide_id)
    attend = params[:attend]
    memo = params[:memo]

    # 実績入力
    achievements.update(achievements_entered: true)

    # ガイド全員の実績入力状態を取得
    tour_guides = TourGuide.where(tour_id: tour_id, achievements_entered: false)
    count = tour_guides.count

    # 参加したガイド全員の実績を入力していない場合、ツアー状態コードを実施済みへ変更する
    Tour.find_by(id: tour_id).update(tour_state_code: TOUR_STATE_CODE_COMPLETE) if count != 0

    # 全てのツアー実績が記入済みであれば、ツアー状態を更新
    Tour.find_by(id: tour_id).update(tour_state_code: TOUR_STATE_CODE_COMPLETE_RECORDED) if count.zero?

    # 出席だけ入力
    achievements.update(attend: attend) unless attend.nil?

    # メモだけ入力
    achievements.update(memo: memo) unless memo.nil?

    # 結果を出力
    render json: json_render_v1(true, achievements)
  end
end

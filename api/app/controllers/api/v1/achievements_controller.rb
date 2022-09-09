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

    # 出席だけ入力
    achievements.update(attend: attend) unless attend.nil?

    # メモだけ入力
    achievements.update(memo: memo) unless memo.nil?

    # 結果を出力
    render json: json_render_v1(true, achievements)
  end
end

# ツアー実績のコントローラーです
class Api::V1::TourAchievementsController < ApplicationController
  include Achievement
  before_action :require_login

  # ツアーに紐づくガイドの実績を取得する（スケジュール入力を求めたガイドの実績一覧）
  def index
    # 取得するガイドのリスト
    guides = GuideSchedule.where(tour_id: params[:tour_id])

    # 情報を取得
    achievements = []
    guides.each do |guide|
      achievements.push(achievement(guide.guide_id))
    end

    response = {}
    response["achievements"] = achievements
    render json: json_render_v1(true, response)
  end
end

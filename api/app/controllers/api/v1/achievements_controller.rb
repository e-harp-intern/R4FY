# 実績を入力するためのコントローラー
class Api::V1::AchievementsController < ApplicationController
  before_action :require_login

  # 実績を入力
  def create
    # createですが、updateで保存しています
    achievements = TourGuide.find_by(id: params[:tour_id], id: params[:guide_id])
    achievements.update(achievements_entered: false)
    render json: json_render_v1(true, achievements)
  end
end

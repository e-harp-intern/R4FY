# ガイドの予定に関連する機能のコントローラーです

class Api::V1::GuideSchedulesController < ApplicationController
  before_action :require_login

  # DBにガイドスケジュール(true/false)を反映
  def update
    token = Token.find_by(token: params[:token])
    guide_schedules = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
    guide_schedules.update(answered: true, possible: params[:possible])
    render json: json_render_v1(true)
  end

  # ガイド情報・関連したツアー情報・入力済の参加可否情報の表示
  def index
    token = Token.find_by(token: params[:token])
    if token.nil?
      render json: json_render_v1(false)
    else
      guide = Guide.find_by(id: token.guide_id)
      tour = Tour.find_by(id: token.tour_id)
      guide_schedules = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
      response = {
        guide: JSON.parse(guide.to_json),
        tour: JSON.parse(tour.to_json),
        answered: JSON.parse(guide_schedules.answered.to_json),
        possible: JSON.parse(guide_schedules.possible.to_json)
      }
      render json: json_render_v1(true, response)
    end
  end
end

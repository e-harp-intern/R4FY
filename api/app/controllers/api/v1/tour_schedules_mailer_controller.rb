require "securerandom"

class Api::V1::TourSchedulesMailerController < ApplicationController
  include Schedule
  before_action :require_login

  def create
    # パラメーター
    guide_schedule = GuideSchedule.find_by(tour_id: params[:tour_id], guide_id: params[:guide_id])

    # ガイドスケジュールが作成済の場合
    unless guide_schedule.nil?
      render json: json_render_v1(false)
      return
    end

    # ガイドスケジュールが作成されていなかった場合
    GuideSchedule.create(tour_id: params[:tour_id], guide_id: params[:guide_id])
    token = Token.new(token: generate_token, tour_id: params[:tour_id], guide_id: params[:guide_id])
    token.save!

    # メール用情報の取得
    tour = Tour.find_by(id: params[:tour_id])
    guide = Guide.find_by(id: params[:guide_id])

    # メール送信
    guide_schedule_mailer(guide, token, tour)

    render json: json_render_v1(true)
  end
end

# ツアー単位のガイドの予定関連
class Api::V1::GuideSchedulesChangeController < ApplicationController
  before_action :require_login

  # ガイドのスケジュールをまとめて強制的に変更する
  def update
    tour_id = params[:tour_id]
    guides_id = params[:guides_id]
    possible = params[:possible]

    # 参加可否強制変更
    guide_schedules = GuideSchedule.where(tour_id: tour_id, guide_id: guides_id)
    ActiveRecord::Base.transaction do
      guide_schedules.each do |guide_schedule|
        guide_schedule.update!(answered: true, possible: possible) unless guide_schedules.nil?
      end
    end

    render json: json_render_v1(true)
    nil

  # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end
end

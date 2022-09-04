# ツアー関連のコントローラーです
require "securerandom"

class Api::V1::ToursController < ApplicationController
  # ツアー一覧を降順取得
  def index
    tours = Tour.order(start_datetime: :DESC)
    render json: json_render_v1(true, tours)
  end

  # 　ツアーの追加
  def create
    # ツアー予定追加に必要な情報を取得
    ApplicationRecord.transaction do
      tour = Tour.new(name: params[:name], start_datetime: params[:start_datetime],
                      end_datetime: params[:end_datetime], adult_num: params[:adult_num], child_num: params[:child_num], guide_num: params[:guide_num], schedule_input_deadline: params[:schedule_input_deadline], remind_date: params[:remind_date], memo: params[:memo], sent_remind: false)
      tour.save!
      # 空の参加可否情報を生成
      guides = Guide.where(is_invalid: false)

      # 追加した予定に対してガイドスケジュール,トークンを作成
      for guide in guides do
        GuideSchedule.create(tour_id: tour.id, guide_id: guide.id)
        Token.new(token: generate_token, tour_id: tour.id, guide_id: guide.id).save!
      end

    rescue ActiveRecord::RecordInvalid
      render json: json_render_v1(false)
      return
    end
    # 予定が作成されたら成功表示
    render json: json_render_v1(true)
  end

  # トークンの生成
  def generate_token
    SecureRandom.urlsafe_base64
  end
end

# ツアー関連のコントローラーです
require "securerandom"

class Api::V1::ToursController < ApplicationController
  before_action :require_login

  # ツアー一覧を降順取得
  def index
    # 条件の初期値を設定
    limit = params[:limit] || 100
    word = params[:word] || ""
    start_date = Date.parse(params[:start_date] || Date.today.prev_month.strftime("%Y-%m-%d"))
    end_date = Date.parse(params[:end_date] || Date.today.strftime("%Y-%m-%d")).tomorrow
    tour_state = params[:tour_state] || [TOUR_STATE_CODE_INCOMPLETE, TOUR_STATE_CODE_ASSIGNED, TOUR_STATE_CODE_COMPLETE, TOUR_STATE_CODE_COMPLETE_RECORDED, TOUR_STATE_CODE_CANCEL]

    # 検索
    tours = Tour
            .where(tour_state_code: tour_state)
            .where("name LIKE ?", "%#{word}%")
            .where("end_datetime < ?", end_date)
            .where("start_datetime > ?", start_date)
            .order(start_datetime: :DESC)
            .limit(limit)
    render json: json_render_v1(true, tours)
  end

  # 　ツアーの追加
  def create
    # トランザクションの追加
    ApplicationRecord.transaction do
      # 新しいツアーを作成
      tour = Tour.new(name: params[:name], start_datetime: params[:start_datetime],
                      end_datetime: params[:end_datetime], adult_num: params[:adult_num], child_num: params[:child_num], guide_num: params[:guide_num], schedule_input_deadline: params[:schedule_input_deadline], remind_date: params[:remind_date], memo: params[:memo], sent_remind: false)
      tour.save!

      # ガイドのリストを取得（削除済みをのぞく）
      guides = Guide.where(is_invalid: false)

      # 追加した予定に対してガイドスケジュール,トークンを作成
      guides.each do |guide|
        GuideSchedule.create(tour_id: tour.id, guide_id: guide.id)
        Token.new(token: generate_token, tour_id: tour.id, guide_id: guide.id).save!
      end
    end

    # 予定が作成されたら成功表示
    render json: json_render_v1(true)
  end

  # トークンの生成
  def generate_token
    SecureRandom.urlsafe_base64
  end
end

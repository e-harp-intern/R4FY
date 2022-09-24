# ツアー詳細のコントローラーです
class Api::V1::TourController < ApplicationController
  before_action :require_login

  # ツアー詳細を表示
  def index
    # 必要な情報を取得
    tours = Tour.find_by(id: params[:id])
    tour_guides = TourGuide.where(tour_id: params[:id]).includes(:guide)
    guide_schedules = GuideSchedule.where(tour_id: params[:id]).includes(:guide)

    # ツアーが存在しない場合
    if tours.nil?
      render json: json_render_v1(false, {}), status: 404
      return
    end

    # レスポンスの形を作成
    response = {
      tour: tours,
      guide_schedules: JSON.parse(guide_schedules.to_json(include: [:guide])),
      tour_guides: JSON.parse(tour_guides.to_json(include: [:guide]))
    }

    render json: json_render_v1(true, response)
  end

  # ツアーを中止にする
  def destroy
    tour = Tour.find_by(id: params[:id])

    # 中止済み
    if tour.tour_state_code == TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(false)
      return
    end

    # 中止処理
    ApplicationRecord.transaction do
      # メールの送信対象を取得
      guides = []
      guides = if tour.tour_state_code == TOUR_STATE_CODE_INCOMPLETE
                 GuideSchedule.where(tour_id: tour.id) # 担当者決定前
               else
                 TourGuide.where(tour_id: tour.id) # ツアー担当決定済の場合
               end

      # 中止処理
      tour.update!(tour_state_code: TOUR_STATE_CODE_CANCEL)

      # メールを送信
      guides.each do |g|
        guide = Guide.find_by(id: g.guide_id)
        TourCancelNotifyMailer.cancel_email(guide, tour).deliver_now
      end
    end
    render json: json_render_v1(true)
    nil

    # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end

  # ツアーの情報を変更する
  def update
    # パラメータ
    tour = Tour.find_by(id: params[:id])
    name = params[:name]
    memo = params[:memo]
    guide_num = params[:guide_num]
    adult_num = params[:adult_num]
    child_num = params[:child_num]
    send_remind = params[:send_remind]
    schedule_input_deadline = params[:schedule_input_deadline]

    # ツアー情報を更新
    ApplicationRecord.transaction do
      tour.update!(name: name) unless name.nil?
      tour.update!(name: memo) unless memo.nil?
      tour.update!(guide_num: guide_num) unless guide_num.nil?
      tour.update!(adult_num: adult_num) unless adult_num.nil?
      tour.update!(child_num: child_num) unless child_num.nil?
      tour.update!(send_remind: send_remind) unless send_remind.nil?
      tour.update!(schedule_input_deadline: schedule_input_deadline) unless schedule_input_deadline.nil?
    end

    render json: json_render_v1(true, tour)

    # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end
end

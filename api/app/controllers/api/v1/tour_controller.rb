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
    tour_delete = Tour.find_by(id: params[:id])

    # ツアー状態コードによって、メールの送信対象を変える
    case tour_delete.tour_state_code

    # 担当者決定前の場合
    when TOUR_STATE_CODE_INCOMPLETE

      guide_schedules = GuideSchedule.where(tour_id: params[:id])

      # ツアー状態をキャンセルに変更
      tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)

      # 全員にメールを送信
      guide_schedules.each do |guide_schedules|
        guides = Guide.find_by(id: guide_schedules.guide_id)
        TourCancelNotifyMailer.cancel_email(guides, tour_delete).deliver_now
      end

      render json: json_render_v1(true)
      nil

    # ツアーが既にキャンセルされていた場合
    when TOUR_STATE_CODE_CANCEL

      render json: json_render_v1(false)

    # ツアー担当決定済の場合
    else

      tour_guides = TourGuide.where(id: params[:id])

      # ツアー状態をキャンセルに変更
      tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)

      # 担当者のみにメールを送信
      tour_guides.each do |tour_guides|
        guide = Guide.find_by(id: tour_guides.guide_id)
        TourCancelNotifyMailer.cancel_email(guide, tour_delete).deliver_now
      end

      render json: json_render_v1(true)
      nil
    end
  end

  # ツアーの情報を変更する
  def update
    # パラメータ
    tour = Tour.find_by(id: params[:id])
    name = params[:name]
    guide_num = params[:guide_num]
    adult_num = params[:adult_num]
    child_num = params[:child_num]
    remind_date = params[:remind_date]
    schedule_input_deadline = params[:schedule_input_deadline]

    # 名前だけを変更する条件
    tour.update(name: name) unless name.nil?

    # 必要ガイド数だけ変更する場合
    tour.update(guide_num: guide_num) unless guide_num.nil?

    # 大人の参加者数だけ変更する場合
    tour.update(adult_num: adult_num) unless adult_num.nil?

    # 子供の人数だけ変更する場合
    tour.update(child_num: child_num) unless child_num.nil?

    # リマインド日付だけ変更する場合
    tour.update(remind_date: remind_date) unless remind_date.nil?

    # 予定入力期限だけ変更する場合
    tour.update(schedule_input_deadline: schedule_input_deadline) unless schedule_input_deadline.nil?

    render json: json_render_v1(true, tour)
  end
end

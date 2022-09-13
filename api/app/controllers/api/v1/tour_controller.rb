# ツアー詳細のコントローラーです
class Api::V1::TourController < ApplicationController
  before_action :require_login

  # ツアー詳細を表示
  def index
    # 必要な情報を取得
    tours = Tour.find_by(id: params[:id])
    tour_guides = TourGuide.where(tour_id: params[:id]).includes(:guide)
    guide_schedules = GuideSchedule.where(tour_id: params[:id]).includes(:guide)

    # レスポンスの形を作成
    response = {
      tour: tours,
      guide_schedules: JSON.parse(guide_schedules.to_json(include: [:guide])),
      tour_guides: JSON.parse(tour_guides.to_json(include: [:guide]))
    }
    render json: json_render_v1(true)
  end

  # ツアーを中止にする
  def destroy
    tour_delete = Tour.find_by(id: params[:id])

    # 担当者決定前の場合
    case tour_delete.tour_state_code
    when TOUR_STATE_CODE_INCOMPLETE

      guide_schedules = GuideSchedule.where(tour_id: params[:id])

      # 全員にメールを送信
      guide_schedules.each do |guide_schedules|
        guides = Guide.find_by(id: guide_schedules.guide_id)
        TourCancelNotifyMailer.cancel_email(guides, tour_delete).deliver_now
      end

      # ツアー状態をキャンセルに変更
      tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)
      render json: json_render_v1(true)
      nil

    # ツアーが既にキャンセルされていた場合
    when TOUR_STATE_CODE_CANCEL

      render json: json_render_v1(false)

    # ツアー担当決定済の場合
    else

      tour_guides = TourGuide.where(id: params[:id])

      # 担当者のみにメールを送信
      tour_guides.each do |tour_guides|
        guide = Guide.find_by(id: tour_guides.guide_id)
        TourCancelNotifyMailer.cancel_email(guide, tour_delete).deliver_now
      end

      # ツアー状態をキャンセルに変更
      tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)
      render json: json_render_v1(true)
      nil
    end
  end
end

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
    render json: json_render_v1(true, response)
  end

  # ツアーを中止にする
  def destroy
    tour_delete = Tour.find_by(id: params[:id])
    guide_id = TourGuide.find_by(id: params[:id]).guide_id

    # 担当者決定後の場合
    if tour_delete.tour_state_code == 2
      guide = Guide.find_by(id: guide_id)
      TourCancelNotifyMailer.cancel_email(guide, tour_delete).deliver_now
      # tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)
      render json: json_render_v1(true, tour_delete)
    else
      # 担当者決定前の場合
      guides_id = GuideSchedule.where(tour_id: params[:id])
      guides = Guide.where(id: guides_id)

      guides.each do |guide|
        TourCancelNotifyMailer.cancel_email(guide, tour_delete).deliver_now
      end

      # tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(true, guides)
    end
    nil
  end
end

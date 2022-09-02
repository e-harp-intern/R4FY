# ツアー詳細のコントローラーです
class Api::V1::TourdetailController < ApplicationController
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
    tour_delete.update(tour_state_code: TOUR_STATE_CODE_CANCEL)
    render json: json_render_v1(true)
  end
end

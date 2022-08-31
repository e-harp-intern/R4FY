class Api::V1::TourdetailController < ApplicationController
  # ツアー詳細を表示
  def index
    guideschedules = GuideSchedule.where(tour_id: params[:id])
    tours = Tour.find_by(id: params[:id])
    tourguides = TourGuide.where(tour_id: params[:id])

    response = { tour: tours, guideschedule: guideschedules, tourguide: tourguides }
    render json: json_render_v1(true, response)
  end
end

class Api::V1::TourdetailController < ApplicationController
  # ツアー詳細を表示
  def index
    guideschedules = GuideSchedule.where(tour_id: params[:id])
    tours = Tour.find_by(id: params[:id])
    tourguides = TourGuide.where(tour_id: params[:id])

    response = { tour: tours, guideschedule: guideschedules, tourguide: tourguides }
    respond_to do |format|
      format.json { render json: response }
    end
  end
end

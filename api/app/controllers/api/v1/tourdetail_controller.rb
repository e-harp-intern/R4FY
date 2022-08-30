class Api::V1::TourdetailController < ApplicationController
  def index
    tour = Tour.find_by(id: params[:id])
    render json: json_render_v1(true, tour)
  end
end

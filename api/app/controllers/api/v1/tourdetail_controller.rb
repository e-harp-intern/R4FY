class Api::V1::TourdetailController < ApplicationController
  # ツアー詳細を表示
  def index
    tour = Tour.find_by(id: params[:id])
    render json: json_render_v1(true, tour)
  end
end

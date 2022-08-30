class Api::V1::TourdetailController < ApplicationController
  def index
    tourid = Tour.find_by(id: params[:id])
    render json: json_render_v1(true, tourid)
  end
end

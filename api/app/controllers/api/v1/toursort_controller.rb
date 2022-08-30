class Api::V1::ToursortController < ApplicationController
  def index
    tours = Tour.order(start_datetime: :DESC)
    render json: json_render_v1(true, tours)
  end
end

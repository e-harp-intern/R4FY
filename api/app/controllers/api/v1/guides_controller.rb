class Api::V1::GuidesController < ApplicationController
  def create
    begin
      user = Guide.new(email: params[:email], name: params[:name], is_invalid: params[:is_invalid]).save!
    rescue StandardError
      render json: json_render_v1(false)
      return
    end
    render json: json_render_v1(true)
  end
end

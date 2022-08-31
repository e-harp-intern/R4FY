class Api::V1::AdminsController < ApplicationController
  def create
    begin
      user = Admin.new(email: params[:email], name: params[:name], password: create_temp_pass).save!
    rescue StandardError
      render json: json_render_v1(false)
      return
    end
    render json: json_render_v1(true)
  end
end

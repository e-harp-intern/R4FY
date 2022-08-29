class Api::V1::SessionsController < ApplicationController
  def create
    user = Admin.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン成功
      render json: json_render_v1(true)
    else
      # ログイン失敗
      render json: json_render_v1(false)
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

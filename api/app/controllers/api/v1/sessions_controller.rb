# ログインをするためのコントローラー
class Api::V1::SessionsController < ApplicationController
  # ログインのメソッド
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

  # ログアウトのメソッド
  def destroy
    session.delete(:user_id)
    @current_user = nil
    render json: json_render_v1(true)
  end
end

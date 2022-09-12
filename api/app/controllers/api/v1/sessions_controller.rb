# ログインをするためのコントローラー
class Api::V1::SessionsController < ApplicationController
  before_action :require_login, except: [:create]

  # ログインのメソッド
  def create
    user = Admin.find_by(email: params[:session][:email].downcase)
    session[:user_id] = nil
    is_invalid = Admin.find_by(email: user.email).is_invalid
    if user&.authenticate(params[:session][:password]) && is_invalid == false
      # ログイン成功
      session[:user_id] = user.id
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

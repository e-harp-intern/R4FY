# 管理者アカウントを作成するためのコントローラー
class Api::V1::AdminsController < ApplicationController
  before_action :require_login

  # 　管理者アカウント作成のメソッド
  def create
    # 管理者アカウントに必要な情報を取得
    begin
      user = Admin.new(email: params[:email], name: params[:name], password: create_temp_pass).save!

    # バリデーション外であればエラー表示
    rescue StandardError
      render json: json_render_v1(false)
      return
    end
    # アカウントが作成されたら成功表示
    render json: json_render_v1(true)
  end

  # 　管理者名を取得する
  def admin_name_show
    # 　管理者名を表示
    render json: json_render_v1(true, @current_user)
  end
end

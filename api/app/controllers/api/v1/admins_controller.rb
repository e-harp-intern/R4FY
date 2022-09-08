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
  def index
    # 　管理者名を表示
    render json: json_render_v1(true, @current_user)
  end

  def delete
    admins_delete = Admin.find_by(id: params[:id])
    admins_delete.update(is_invalid: true)
    render json: json_render_v1(true)
  end

  # 　管理者情報の変更をする
  def update
    admin = Admin.find_by(id: params[:id])
    name = params[:name]
    email = params[:email]

    # 　名前だけを変更する条件
    admin.update(name: name) unless name.nil?

    # 　メールだけを変更する条件
    admin.update(email: email) unless email.nil?

    render json: json_render_v1(true)
  end
end

# 管理者アカウントを作成するためのコントローラー
class Api::V1::AdminsController < ApplicationController
  before_action :require_login

  # 　管理者アカウント作成のメソッド
  def create
    # 管理者アカウントに必要な情報を取得
    begin
      password = create_temp_pass
      admin = Admin.new(email: params[:email], name: params[:name], password: password)
      admin.save!

      # アカウント作成メールを送信
      CreateAccountNotifyMailer.creation_email(admin, password).deliver_now

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
    # /meの場合、自身の情報を取得
    if params[:id] == "me"
      response = {}
      response["admin"] = @current_user
    else
      # IDから取得
      admin = Admin.find(params[:id])

      # 存在しない場合はエラーを返す
      if admin.nil? || admin.is_invalid
        render json: json_render_v1(false, status: 204)
        return
      end

      # 実績の取得
      response = {}
      response["admin"] = admin

    end
    render json: json_render_v1(true, response)
  end

  # アカウントの論理削除
  def delete
    admins_delete = Admin.find_by(id: params[:id])
    admins_delete.update(is_invalid: true)

    # アカウント削除の通知メール
    DeleteAccountNotifyMailer.delete_email(admins_delete).deliver_now

    render json: json_render_v1(true)
  end

  # 管理者情報の変更をする
  def update
    admin = Admin.find_by(id: params[:id])

    # 変更を行う管理者が変更対象の管理者と一致するか
    if admin == @current_user
      name = params[:name]
      email = params[:email]
      password = params[:password]

      # 名前だけを変更する条件
      admin.update(name: name) unless name.nil?

      # メールだけを変更する条件
      admin.update(email: email) unless email.nil?

      # パスワードだけを変更する条件
      admin.update(password: password) unless password.nil?

      render json: json_render_v1(true)
      nil

    # 他の管理者のIDを指定した場合
    elsif @current_user.id != admin.id
      render json: json_render_v1(false, status: 403)
      nil

    # それ以外
    else
      render json: json_render_v1(false)
    end
  end
end

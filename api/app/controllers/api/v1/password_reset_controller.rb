require "securerandom"
class Api::V1::PasswordResetController < ApplicationController
  # パスワードリセット
  def create
    # 管理者の指定
    admin = Admin.find_by(id: params[:id])

    if admin.is_invalid == false
      # 指定したIDのパスワードリセットトークンをすべて削除
      password_reset_tokens = PasswordResetToken.where(admin_id: params[:id])
      password_reset_tokens.destroy_all

      # トークンの生成
      token = PasswordResetToken.new(token: generate_token, admin_id: params[:id])
      token.save!

      url = format(URL_ADMIN_PASSWORD_RESET_TOKEN, token: token.token)
      mail = PasswordResetMailer.creation_email(admin, url).deliver_now

      render json: json_render_v1(true)
    else
      render json: json_render_v1(false)
    end
    nil
  end
end

# パスワードの再設定メールを送信するコントローラー
class Api::V1::PasswordResetController < ApplicationController
  # パスワードリセット
  def create
    ApplicationRecord.transaction do
      # 管理者の検索
      admin = Admin.find_by(email: params[:email])

      # 無効なユーザー
      if admin.nil? || admin.is_invalid
        render json: json_render_v1(false)
        return
      end

      # 指定したIDのパスワードリセットトークンをすべて削除
      password_reset_tokens = PasswordResetToken.where(admin_id: admin.id)
      password_reset_tokens.destroy_all

      # トークンの生成
      token = PasswordResetToken.new(token: generate_token, admin_id: admin.id)
      token.save!

      # メールの送信
      url = format(URL_ADMIN_PASSWORD_RESET_TOKEN, token: token.token)
      mail = PasswordResetMailer.creation_email(admin, url).deliver_now
    end
    render json: json_render_v1(true)
    nil

    # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end
end

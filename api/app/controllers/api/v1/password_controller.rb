# トークンを用いてパスワードを変更するAPI
class Api::V1::PasswordController < ApplicationController
  def create
    ApplicationRecord.transaction do
      token = PasswordResetToken.find_by(token: params[:token])
      admin = Admin.find_by(id: token.admin_id)
      admin.update!(password: params[:password])
      token.destroy!
    end
    render json: json_render_v1(true)

  # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end
end

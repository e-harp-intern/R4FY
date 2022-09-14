# トークンを用いてパスワードを変更するAPI
class Api::V1::PasswordController < ApplicationController
  def create
    token = PasswordResetToken.find_by(token: params[:token])
    admin = Admin.find_by(id: token.admin_id)

    admin.update(password: params[:password])
    token.destroy
    render json: json_render_v1(true)
  end
end

# アカウントを復活させるためのコントローラー
class Api::V1::AdminReEnableController < ApplicationController
  before_action :require_login

  # 管理者アカウント復活のメソッド
  def create
    begin
      # 復活対象を取得
      admins = Admin.find_by(id: params[:id])

      # 自分自身のIDを指定した場合
      if admins.id == @current_user.id
        render json: json_render_v1(false)
        return
      end

      # アカウントの論理復活
      admins.update(is_invalid: false)

    # 失敗時
    rescue StandardError
      render json: json_render_v1(false)
      return
    end

    render json: json_render_v1(true)
  end
end

# アカウントを復活させるためのコントローラー
class Api::V1::GuideReEnableController < ApplicationController
  before_action :require_login

  # ガイドアカウント復活のメソッド
  def create
    begin
      # 復活対象を取得
      guides = Guide.find_by(id: params[:id])

      # 自分自身のIDを指定した場合
      if guides.id == @current_user.id
        render json: json_render_v1(false)
        return
      end

      # アカウントの論理復活
      guides.update(is_invalid: false)

    # 失敗時
    rescue StandardError
      render json: json_render_v1(false)
      return
    end

    render json: json_render_v1(true)
  end
end

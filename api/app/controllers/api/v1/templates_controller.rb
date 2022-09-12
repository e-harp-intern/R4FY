# テンプレートを一覧で取得するコントローラーです

class Api::V1::TemplatesController < ApplicationController
  before_action :require_login

  # ツアーテンプレートの取得
  def index
    # 条件の初期値を設定
    name = params[:name] || ""

    # 検索
    tours = TourTemplate.where("name LIKE ?", "%#{name}%")

    response = {}
    response["tours"] = tours
    render json: json_render_v1(true, response)
  end
end

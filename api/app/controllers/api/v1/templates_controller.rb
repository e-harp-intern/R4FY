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

  # ツアーテンプレートの作成
  def create
    tour_template = TourTemplate.new(name: params[:name], start_datetime: params[:start_datetime],
                                     end_datetime: params[:end_datetime], guide_num: params[:guide_num])

    # ツアーテンプレートの保存
    ApplicationRecord.transaction do
      tour_templates.save!
    end

    # 作成したツアーテンプレートの表示
    render json: json_render_v1(true, tour_templates)
  end
end

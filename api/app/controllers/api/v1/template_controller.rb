# テンプレートを個別で取得するコントローラーです

class Api::V1::TemplateController < ApplicationController
  before_action :require_login

  # ツアーテンプレートの取得
  def index
    templates = TourTemplate.find_by(id: params[:id])
    render json: json_render_v1(true, templates)
  end
end

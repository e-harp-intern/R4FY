# API全体のベースとなるコントローラー
class ApplicationController < ActionController::API
  include Common
  include ActionController::MimeResponds

  # ハンドルしきれなかったエラーは500エラー扱い
  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  # ルーティングエラー
  def routing_error
    raise ActionController::RoutingError.new(params[:path]), "routing error"
  end

  # 404 エラー
  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render json: json_render_v1(false, { error: "not found", status: 404 })
  end

  # 500エラー
  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e
    render json: json_render_v1(false, { error: "server error", status: 500 })
  end

  private

  # ログインしていないと使用できない機能には controller の class 内に before_action :require_login を定義
  # def require_login
  #   # @current_user = User.find_by(id: session[:user_id])
  #   @current_user = @current_user || User.find_by(id: session[:user_id])
  #   return if @current_user

  #   render json: json_render_v1(false, { error: "unauthorized" }), status: :unauthorized
  # end

  # 返すデータの枠 （status ...true=success, false=erro, nil=none）
  def json_render_v1(flg = nil, json = {})
    {
      status: flg.nil? ? "none" : (flg ? "success" : "error"),
      data: json
    }
  end
end

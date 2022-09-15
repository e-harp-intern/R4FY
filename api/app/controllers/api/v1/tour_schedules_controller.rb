# 予定入力メールを再送するコントローラーです

class Api::V1::TourSchedulesController < ApplicationController
  before_action :require_login

  # 予定入力メールを再送
  def create
    # ツアーを取得
    tour = Tour.find_by(id: params[:tour_id])

    # ガイドのリストを取得（削除済みをのぞく）
    guides = Guide.where(id: params[:guides])

    # ガイドに予定入力メールを送信
    guides.each do |guide|
      # ガイドが存在する場合、トークンを取得
      token = Token.find_by(tour_id: tour.id, guide_id: guide.id) unless guide.nil? && guide.is_invalid

      # トークンが存在する場合、メールを送信
      unless token.nil?
        url = format(URL_GUIDE_SCHEDULE_TOKEN, token: token.token)
        GuideScheduleInputMailer.creation_email(guide, url).deliver_now
      end
    end

    render json: json_render_v1(true)
  end
end

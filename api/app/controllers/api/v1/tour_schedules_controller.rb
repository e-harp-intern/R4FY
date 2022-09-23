# 予定入力メールを再送するコントローラーです

class Api::V1::TourSchedulesController < ApplicationController
  include Schedule
  before_action :require_login

  # 予定入力メールを再送
  def create
    ApplicationRecord.transaction do
      # ツアー情報を取得
      tour = Tour.find(params[:tour_id])

      # ガイドのリストを取得（削除済みをのぞく）
      guides = Guide.where(id: params[:guides]).where(is_invalid: false)

      # ガイドに予定入力メールを送信
      guides.each do |guide|
        # ガイドが存在する場合、トークンを取得
        token = Token.find_by(tour_id: params[:tour_id], guide_id: guide.id) unless guide.nil?

        # トークンが無い場合は作成
        if token.nil?
          token = Token.new(token: generate_token, tour_id: tour.id, guide_id: guide.id)
          token.save!
        end

        # メールを送信
        guide_schedule_mailer(guide, token, tour)
      end
    end

    # 成功時
    render json: json_render_v1(true)

    # 失敗時
  rescue ActiveRecord::RecordInvalid
    render json: json_render_v1(false)
  end
end

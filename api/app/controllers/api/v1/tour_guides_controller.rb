# ツアー担当ガイド詳細のコントローラーです
class Api::V1::TourGuidesController < ApplicationController
  before_action :require_login

  # 担当ガイドを設定するためのAPI
  def create
    # トランザクション（失敗時は保存しない）
    ApplicationRecord.transaction do
      tour_id = params[:id]
      guides = params[:guides]

      # 同じツアーIDの担当情報を削除（物理）
      TourGuide.where(tour_id: tour_id).destroy_all

      # 追加（TODO: 削除済みのガイドを指定した場合はエラー）
      for g in guides
        t = TourGuide.new(tour_id: tour_id, guide_id: g)
        t.save
      end
    end

    # TODO: 成功時はメールを送信 #75 で実装予定

    # 成功時
    render json: json_render_v1(true)
    return

    # バリデーションエラー
    ActiveRecord RecodeInvalid: e
    render json: json_render_v1(false, { hint => "validation error" })
    nil

    # その他失敗時
  rescue StandardError => e
    render json: json_render_v1(false)
  end
end

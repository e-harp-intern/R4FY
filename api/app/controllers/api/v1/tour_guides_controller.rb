# ツアー担当ガイドのコントローラーです
class Api::V1::TourGuidesController < ApplicationController
  before_action :require_login

  # 担当ガイドを設定するためのAPI
  def create
    # パラメータの受け取り
    tour_id = params[:id]
    guides = params[:guides]

    # send_mailは初期値はtrue
    send_mail = params[:send_mail] || true

    # トランザクション（失敗時は保存しない）
    ApplicationRecord.transaction do
      # 同じツアーIDの担当情報を削除（物理）
      TourGuide.where(tour_id: tour_id).destroy_all

      # 追加（TODO: 削除済みのガイドを指定した場合はエラー）
      guides.each do |g|
        t = TourGuide.new(tour_id: tour_id, guide_id: g)
        t.save
      end

      # ツアーの状態を担当者決定済みに更新
      Tour.find(tour_id).update(tour_state_code: TOUR_STATE_CODE_ASSIGNED)
    end

    # 成功時にsend_mailがtrueなら担当者にメールを送信
    if send_mail == true
      tour = Tour.find(tour_id)
      guides.each do |g|
        guide = Guide.find_by(id: g)
        AssignNotifyMailer.creation_email(guide, tour).deliver_now
      end
    end

    # 成功時
    render json: json_render_v1(true)
    nil

    # その他失敗時
  rescue StandardError => e
    render json: json_render_v1(false)
  end

  # 担当ガイドをリセットするためのAPI
  def destroy
    # トランザクション（失敗時は保持しない）
    ApplicationRecord.transaction do
      tour_id = params[:id]
      tour_guides = TourGuide.where(tour_id: tour_id)
      tour_delete = Tour.find_by(id: params[:id])

      # 全員にメールを送信
      tour_guides.each do |tour_guide|
        guide = Guide.find_by(id: tour_guide.guide_id)
        AssignCancelNotifyMailer.cancel_email(guide, tour_delete).deliver_now
      end

      # 同じツアーIDの担当情報を削除（物理）
      tour_guides.destroy_all

      # ツアーの状態を「担当ガイド未決定」に更新
      Tour.find(tour_id).update(tour_state_code: TOUR_STATE_CODE_INCOMPLETE)
    end

    # 成功時
    render json: json_render_v1(true)
    nil

    # その他失敗時
  rescue StandardError => e
    render json: json_render_v1(false)
  end
end

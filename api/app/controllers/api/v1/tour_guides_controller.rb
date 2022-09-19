# ツアー担当ガイドのコントローラーです
class Api::V1::TourGuidesController < ApplicationController
  before_action :require_login

  # 担当ガイドを設定するためのAPI
  def create
    # パラメータの受け取り
    tour_id = params[:id]
    guides = params[:guides]
    send_mail = params[:send_mail] || true
    new_assign = []
    remove_assign = []
    is_first_assign = false
    tour = Tour.find(tour_id)

    ApplicationRecord.transaction do
      # 担当から外れたガイドを取得
      del_guides = TourGuide.where(tour_id: tour_id).where.not(guide_id: guides)
      del_guides.each do |g|
        remove_assign.push(g)
      end
      del_guides.destroy_all

      # 担当ガイドを追加（TODO: 削除済みのガイドを指定した場合はエラー）
      guides.each do |g|
        next unless TourGuide.find_by(tour_id: tour_id, guide_id: g).nil?

        t = TourGuide.new(tour_id: tour_id, guide_id: g)
        new_assign.push(t)
        t.save
      end

      # ツアーの状態を担当者決定済みに更新
      is_first_assign = (tour.tour_state_code < TOUR_STATE_CODE_ASSIGNED)
      tour.update(tour_state_code: TOUR_STATE_CODE_ASSIGNED) if is_first_assign

      # 成功時にsend_mailがtrueなら担当者にメールを送信
      if send_mail == true
        # 新しく担当者になった人へメール送信
        new_assign.each do |g|
          AssignNotifyMailer.creation_email(Guide.find(g.guide_id), tour).deliver_now
        end

        # 担当から外れた場合に送信
        remove_assign.each do |g|
          AssignCancelNotifyMailer.cancel_email(Guide.find(g.guide_id), tour).deliver_now
        end

        # 担当にならなかった場合に送信
        if is_first_assign
          no_assign_guides = GuideSchedule.where(tour_id: tour_id).where.not(guide_id: guides)
          no_assign_guides.each do |g|
            NotAssignMailer.creation_email(Guide.find(g.guide_id), tour).deliver_now
          end
        end
      end
    end

    # 成功時
    render json: json_render_v1(true)
    nil

    # その他失敗時
  rescue StandardError => e
    render json: json_render_v1(false)
  end
end

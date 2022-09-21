# 予定入力メールを再送するコントローラーです

class Api::V1::TourCompleteController < ApplicationController
  before_action :require_login

  # ツアーを強制的に完了状態にする
  def update
    tour = Tour.find(params[:id])

    # 状態変更ができない場合
    if tour.nil? || tour.tour_state_code >= TOUR_STATE_CODE_COMPLETE
      render json: json_render_v1(false)
      return
    end

    # 状態を変更
    tour.update(tour_state_code: TOUR_STATE_CODE_COMPLETE)

    # 成功を返却
    render json: json_render_v1(true, tour)
  end
end

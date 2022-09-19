# 実績を入力するためのコントローラー
class Api::V1::AchievementsController < ApplicationController
  before_action :require_login

  # 実績を入力
  def create
    response = {}

    ApplicationRecord.transaction do
      # 実績情報を取得
      tour_id = params[:tour_id]
      guide_id = params[:guide_id]
      attend = params[:attend]
      memo = params[:memo]
      achievements = TourGuide.find_by(tour_id: tour_id, guide_id: guide_id)

      # 未入力の実績情報数を取得
      tour = Tour.find(tour_id)
      count_no_input = TourGuide.where(tour_id: tour_id, achievements_entered: false).count

      # 参加したガイド全員の実績を入力していない場合、ツアー状態コードを実施済みへ変更する
      tour.update(tour_state_code: TOUR_STATE_CODE_COMPLETE) if count_no_input != 0 && tour.tour_state_code < TOUR_STATE_CODE_COMPLETE

      # 全てのツアー実績が記入済みであれば、ツアー状態を更新
      tour.update(tour_state_code: TOUR_STATE_CODE_COMPLETE_RECORDED) if count_no_input.zero? && tour.tour_state_code < TOUR_STATE_CODE_COMPLETE_RECORDED

      # 実績入力
      achievements.update(achievements_entered: true)
      achievements.update(attend: attend) unless attend.nil?
      achievements.update(memo: memo) unless memo.nil?

      # レスポンス
      response = achievements
    end

    # 結果を出力
    render json: json_render_v1(true, response)
    nil

    # その他失敗時
  rescue StandardError => e
    render json: json_render_v1(false)
  end
end

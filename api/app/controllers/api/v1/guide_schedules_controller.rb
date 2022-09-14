# ガイドの予定に関連する機能のコントローラーです

class Api::V1::GuideSchedulesController < ApplicationController
  before_action :require_login, except: %i[index update]

  # DBにガイドスケジュール(true/false)を反映
  def update
    # パラメータ
    token = Token.find_by(token: params[:token])
    guide = Guide.find_by(id: token.guide_id)
    tour = Tour.find_by(id: token.tour_id)

    # ツアーが中止済みの場合
    if tour.tour_state_code == TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(false, { state: "tour canceled" })
      return
    end

    # ガイドアカウントが無効な場合
    if guide.is_invalid == true
      render json: json_render_v1(false)
      return
    end

    # 参加可否入力期限が過ぎていた場合
    if tour.schedule_input_deadline <= DateTime.now
      render json: json_render_v1(false, { state: "error" })
      return
    end

    # ガイドアカウントが有効な場合
    guide_schedules = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
    guide_schedules.update(answered: true, possible: params[:possible])
    render json: json_render_v1(true, guide)
  end

  # ガイド情報・関連したツアー情報・入力済の参加可否情報の表示
  def index
    # パラメーター
    token = Token.find_by(token: params[:token])
    tour = Tour.find_by(id: token.tour_id)

    # ツアーが中止済みの場合
    if tour.tour_state_code == TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(false, { state: "tour canceled" })
      return
    end

    # トークンが存在しないとき
    if token.nil?
      render json: json_render_v1(false)
      return
    end

    guide = Guide.find_by(id: token.guide_id)
    tour = Tour.find_by(id: token.tour_id)
    guide_schedules = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
    response = {
      guide: JSON.parse(guide.to_json),
      tour: JSON.parse(tour.to_json),
      answered: JSON.parse(guide_schedules.answered.to_json),
      possible: JSON.parse(guide_schedules.possible.to_json)
    }

    render json: json_render_v1(true, response)
  end
end

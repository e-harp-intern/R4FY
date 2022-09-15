# ガイドの予定に関連する機能のコントローラーです

class Api::V1::GuideSchedulesController < ApplicationController
  before_action :require_login, except: %i[index update]

  # DBにガイドスケジュール(true/false)を反映
  def update
    # トークンパラメータ
    token = Token.find_by(token: params[:token])

    # トークンが存在しないとき
    if token.nil?
      render json: json_render_v1(false)
      return
    end

    # ツアーパラメーター
    tour = Tour.find_by(id: token.tour_id)

    # ツアーが中止済みの場合
    if tour.tour_state_code == TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(false, { state: "tour canceled" })
      return
    end

    # ツアーが開始済みの場合・担当者が決定済
    if tour.start_datetime < Date.today || tour.tour_state_code != TOUR_STATE_CODE_INCOMPLETE
      render json: json_render_v1(false)
      return
    end

    # ガイドパラメーター
    guide = Guide.find_by(id: token.guide_id)

    # ガイドアカウントが無効・参加可否入力期限が過ぎていた場合
    if guide.is_invalid == true || tour.schedule_input_deadline <= DateTime.now
      render json: json_render_v1(false)
      return
    end

    # ガイドアカウントが有効な場合
    guide_schedule = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
    guide_schedule.update(answered: true, possible: params[:possible])
    render json: json_render_v1(true, guide)
  end

  # ガイド情報・関連したツアー情報・入力済の参加可否情報の表示
  def index
    # トークンパラメーター
    token = Token.find_by(token: params[:token])

    # トークンが存在しないとき
    if token.nil?
      render json: json_render_v1(false)
      return
    end

    # ツアーパラメーター
    tour = Tour.find_by(id: token.tour_id)

    # ツアーが中止済みの場合
    if tour.tour_state_code == TOUR_STATE_CODE_CANCEL
      render json: json_render_v1(false, { state: "tour canceled" })
      return
    end

    # ツアーが開始済みの場合・担当者が決定済の場合
    if tour.start_datetime < Date.today || tour.tour_state_code != TOUR_STATE_CODE_INCOMPLETE
      render json: json_render_v1(false)
      return
    end

    # トークンが存在し、ツアーが中止されていないとき
    guide = Guide.find_by(id: token.guide_id)
    tour = Tour.find_by(id: token.tour_id)
    guide_schedule = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)

    # 出力するデータの整形
    response = {
      guide: guide,
      tour: tour,
      guide_schedule: guide_schedule
    }

    render json: json_render_v1(true, response)
  end
end

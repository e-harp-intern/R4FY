# ツアー関連のコントローラーです
require "securerandom"

class Api::V1::ToursController < ApplicationController
  before_action :require_login

  # ツアー一覧を降順取得
  def index
    # 条件の初期値を設定
    limit = params[:limit] || 100
    word = params[:word] || ""
    start_date = Date.parse(params[:start_date] || Date.today.prev_month.strftime("%Y-%m-%d"))
    end_date = Date.parse(params[:end_date] || "9999-12-30").tomorrow
    tour_state = params[:tour_state] || [TOUR_STATE_CODE_INCOMPLETE, TOUR_STATE_CODE_ASSIGNED, TOUR_STATE_CODE_COMPLETE, TOUR_STATE_CODE_COMPLETE_RECORDED, TOUR_STATE_CODE_CANCEL]

    # 検索
    tours = Tour
            .where(tour_state_code: tour_state)
            .where("name LIKE ?", "%#{word}%")
            .where("end_datetime < ?", end_date)
            .where("start_datetime > ?", start_date)
            .order(start_datetime: :ASC)
            .limit(limit)
    render json: json_render_v1(true, tours)
  end

  # 　ツアーの追加
  def create
    # 入力期限パラメーター
    schedule_input_deadline = params[:schedule_input_deadline]

    # 入力期限が無記入, 空文字のとき
    schedule_input_deadline = "9999-12-30" if [nil, ""].include?(schedule_input_deadline)

    # リマインドパラメーター
    remind_date = params[:remind_date]

    # リマインドが無記入, 空文字のとき
    remind_date = "9999-12-30" if [nil, ""].include?(remind_date)

    # 新しいツアーを作成
    tour = Tour.new(name: params[:name], start_datetime: params[:start_datetime],
                    end_datetime: params[:end_datetime], adult_num: params[:adult_num], child_num: params[:child_num], guide_num: params[:guide_num], schedule_input_deadline: schedule_input_deadline, remind_date: remind_date, memo: params[:memo], sent_remind: false)

    # ガイドのリストを取得（削除済みをのぞく）
    guides = Guide.where(is_invalid: false)

    # トランザクションの処理
    ApplicationRecord.transaction do
      # ツアーを保存
      tour.save!

      # 追加した予定に対してガイドスケジュール,トークンを作成
      guides.each do |guide|
        GuideSchedule.create(tour_id: tour.id, guide_id: guide.id)
        Token.new(token: generate_token, tour_id: tour.id, guide_id: guide.id).save!
      end
    end

    # ガイドに予定入力メールを送信
    guides.each do |guide|
      token = guide.tokens.find_by(tour_id: tour.id)
      url = format(URL_GUIDE_SCHEDULE_TOKEN, token: token.token)
      GuideScheduleInputMailer.creation_email(guide, url).deliver_now
    end

    # 入力したツアー情報を取得
    response = {
      tour: tour
    }

    # 成功表示と入力したツアー情報表示
    render json: json_render_v1(true, response)
  end

  # トークンの生成
  def generate_token
    SecureRandom.urlsafe_base64
  end

  # ガイドの参加可否情報を変更
  def update
    tour_id = params[:tour_id]
    guide_id = params[:guide_id]
    guide_schedules = GuideSchedule.find_by(tour_id: tour_id, guide_id: guide_id)
    possible = params[:possible]

    # 参加可否入力
    guide_schedules.update(answered: true, possible: possible)
    render json: json_render_v1(true, guide_schedules)
  end
end

# ツアー関連のコントローラーです
require "securerandom"

class Api::V1::ToursController < ApplicationController
  include Schedule
  before_action :require_login

  # ツアー一覧を降順取得
  def index
    # 条件の初期値を設定
    limit = params[:limit] || 100
    word = params[:word] || ""
    start_date = Date.parse(params[:start_date] || Date.today.prev_month.strftime("%Y-%m-%d"))
    end_date = Date.parse(params[:end_date] || "9999-12-30").tomorrow
    tour_state = params[:tour_state] || [TOUR_STATE_CODE_INCOMPLETE, TOUR_STATE_CODE_ASSIGNED, TOUR_STATE_CODE_COMPLETE, TOUR_STATE_CODE_CANCEL]

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
    schedule_input_deadline = nil if [nil, ""].include?(schedule_input_deadline)

    # リマインドパラメーター
    send_remind = params[:send_remind]

    # リマインドが無記入, 空文字のとき
    send_remind = true if [nil, ""].include?(send_remind)

    # 子供パラメーター
    child_num = params[:child_num]
    child_num = 0 if [nil, ""].include?(child_num)

    # 大人パラメーター
    adult_num = params[:adult_num]
    adult_num = 0 if [nil, ""].include?(adult_num)

    # ガイドパラメーター
    guide_num = params[:guide_num]
    guide_num = 0 if [nil, ""].include?(guide_num)

    # 新しいツアーを作成
    tour = Tour.new(name: params[:name], start_datetime: params[:start_datetime],
                    end_datetime: params[:end_datetime], adult_num: adult_num, child_num: child_num, guide_num: guide_num, schedule_input_deadline: schedule_input_deadline, send_remind: send_remind, memo: params[:memo])

    # ガイドのリストを取得（削除済みをのぞく）
    guides = Guide.where(is_invalid: false)

    # メール送信フラグ
    send_mail = params[:send_mail].nil? ? true : params[:send_mail]
    send_mail = false if Date.parse(params[:start_datetime]) < Date.today

    # トランザクションの処理
    ApplicationRecord.transaction do
      # ツアーを保存
      tour.save!

      # 追加した予定に対してガイドスケジュール,トークンを作成
      guides.each do |guide|
        GuideSchedule.create(tour_id: tour.id, guide_id: guide.id)
        Token.new(token: generate_token, tour_id: tour.id, guide_id: guide.id).save!
      end

      # ガイドに予定入力メールを送信
      if send_mail
        guides.each do |guide|
          token = guide.tokens.find_by(tour_id: tour.id, guide_id: guide.id)
          guide_schedule_mailer(guide, token, tour)
        end
      end
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

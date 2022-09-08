# ガイドアカウントを作成するためのコントローラー
class Api::V1::GuidesController < ApplicationController
  before_action :require_login

  # ガイドアカウントを作成するメソッド
  def create
    # ガイドアカウントに必要な情報を取得
    begin
      guide = Guide.new(email: params[:email], name: params[:name], memo: params[:memo])
      guide.save!

      # アカウント作成メールを送信
      CreateAccountNotifyMailer.creation_email(guide, nil).deliver_now

    # バリデーション外であればエラー表示
    rescue StandardError
      render json: json_render_v1(false)
      return
    end

    # アカウントが作成されたら成功表示
    render json: json_render_v1(true)
  end

  # ガイドアカウントの論理削除
  def delete
    guides_delete = Guide.find_by(id: params[:id])
    guides_delete.update(is_invalid: true)
    render json: json_render_v1(true)
  end

  # 　ガイド情報の変更をする
  def update
    guide = Guide.find_by(id: params[:id])
    name = params[:name]
    email = params[:email]
    memo = params[:memo]

    # 　名前だけを変更する条件
    guide.update(name: name) unless name.nil?

    # 　メールだけを変更する条件
    guide.update(email: email) unless email.nil?

    # 　メモだけを変更する条件
    guide.update(memo: memo) unless memo.nil?

    render json: json_render_v1(true)
  end

  # DBにガイドスケジュール(true/false)を反映
  def update
    token = Token.find_by(token: params[:token])
    guide_schedules = GuideSchedule.find_by(guide_id: token.guide_id, tour_id: token.tour_id)
    guide_schedules.update(answered: true, possible: params[:possible])
    render json: json_render_v1(true)
  end

  # ガイド情報・関連したツアー情報・入力済の参加可否情報の表示
  def index
    token = Token.find_by(token: params[:token])
    if token.nil?
      render json: json_render_v1(false)
    else
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
end

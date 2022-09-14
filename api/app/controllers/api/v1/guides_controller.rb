# ガイドアカウントを作成するためのコントローラー
class Api::V1::GuidesController < ApplicationController
  include Achievement
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

  # ガイド詳細の取得
  def index
    # 情報の取得
    guide = Guide.find(params[:id])

    # 存在しない場合はエラーを返す
    if guide.nil? || guide.is_invalid
      render json: json_render_v1(false, status: 204)
      return
    end

    # 実績の取得
    response = {}
    response["guide"] = guide
    response["achievement"] = achievement(params[:id])

    render json: json_render_v1(true, response)
  end

  # ガイドアカウントの論理削除
  def destroy
    guides_delete = Guide.find_by(id: params[:id])
    guides_delete.update(is_invalid: true)

    # トークンの削除
    tokens = Token.where(guide_id: params[:id])
    tokens.destroy_all

    # アカウント削除の通知メール
    DeleteAccountNotifyMailer.delete_email(guides_delete).deliver_now

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
end

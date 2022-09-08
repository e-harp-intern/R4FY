# ガイドアカウントを作成するためのコントローラー
class Api::V1::GuidesController < ApplicationController
  before_action :require_login

  # ガイドアカウントを作成するメソッド
  def create
    # ガイドアカウントに必要な情報を取得
    begin
      user = Guide.new(email: params[:email], name: params[:name], memo: params[:memo]).save!

    # バリデーション外であればエラー表示
    rescue StandardError
      render json: json_render_v1(false)
      return
    end
    # アカウントが作成されたら成功表示
    render json: json_render_v1(true)
  end

  def delete
    guides_delete = Guide.find_by(id: params[:id])
    guides_delete.update(is_invalid: true)
    render json: json_render_v1(true)
  end

  # 　ガイド情報の変更をする
  def update
    @admin = Guide.find(params[:id])
    update_name = params[:name]
    update_email = params[:email]
    update_memo = params[:memo]

    # 　名前だけを変更する条件
    @admin.update(name: params[:name]) unless update_name.nil?

    # 　メールだけを変更する条件
    @admin.update(email: params[:email]) unless update_email.nil?

    # 　メモだけを変更する条件
    @admin.update(memo: params[:memo]) unless update_memo.nil?

    render json: json_render_v1(true)
  end
end

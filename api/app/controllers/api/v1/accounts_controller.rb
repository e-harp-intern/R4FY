# アカウント一覧を取得するコントローラーです

class Api::V1::AccountsController < ApplicationController
  before_action :require_login

  # アカウント一覧を取得
  def index
    # 条件の初期値を設定

    name = params[:name] || "" # 検索に名前があるかないか
    email = params[:email] || "" # 検索にメールがあるかないか
    include_invalid = params[:include_invalid] || false # 無効なユーザーを含むか

    account_admins = Admin
                     .where("name LIKE ?", "%#{name}%")
                     .where("email LIKE ?", "%#{email}%")
                     .where(is_invalid: [include_invalid, false])
    account_guides = Guide
                     .where("name LIKE ?", "%#{name}%")
                     .where("email LIKE ?", "%#{email}%")
                     .where(is_invalid: [include_invalid, false])

    response = {
        admins: account_admins,
        guides: account_guides
    }
    render json: json_render_v1(true, response)
  end
end

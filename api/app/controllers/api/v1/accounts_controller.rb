# アカウント一覧を取得するコントローラーです

class Api::V1::AccountsController < ApplicationController
  before_action :require_login

  # アカウント一覧を取得
  def index
    # 条件の初期値を設定
    # 検索に名前があるかないか
    name = params[:name] || ""
    # 検索にメールがあるかないか
    email = params[:email] || ""

    account_admins = Admin
                     .where("name LIKE ?", "%#{name}%")
                     .where("email LIKE ?", "%#{email}%")
    account_guides = Guide
                     .where("name LIKE ?", "%#{name}%")
                     .where("email LIKE ?", "%#{email}%")

    response = {
        admins: account_admins,
        guides: account_guides
    }
    render json: json_render_v1(true, response)
  end
end

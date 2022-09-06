# アカウント一覧を取得するコントローラーです

class Api::V1::AccountsController < ApplicationController
    before_action :require_login

    #管理者アカウント一覧を取得
    def index
        account_admins = Admin.where(is_invalid: false)
        account_guides = Guide.where(is_invalid: false)
        response = {
            admins: account_admins,
            guides: account_guides
        }
        render json: json_render_v1(true, response)
    end

end
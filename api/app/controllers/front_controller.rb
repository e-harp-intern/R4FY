# フロントの表示用
# > CSS等はpublicから直接返す
class FrontController < ActionController::Base
  def index
    path = request.fullpath.split("/")

    # APIの場合は 404 JSON
    if path.length >= 2 && path[1] == "api"
      render json: {status: "error", data: {}}, 404
      return
    end


    # 管理者ログインチェック
    @current_user = @current_user || Admin.find_by(id: session[:user_id])
    if @current_user
      render file: Rails.root.join("public/index.html"), status: 200, layout: false,
             content_type: "text/html"
      return
    end

    # トークンでのログインチェック
    if path.length >= 4 && path[1] == "guides" && path[3] == "schedules"
      token = path[2]
      if Token.find_by(token: token) != nil
        render file: Rails.root.join("public/index.html"), status: 200, layout: false,
               content_type: "text/html"
        return
      end
    end

    # 権限がない場合はログインページへリダイレクト
    redirect_to "/"
  end
end

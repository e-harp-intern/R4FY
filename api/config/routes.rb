Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          # セッション
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"

          # アカウント
          post "guides" => "guides#create"
          post "admins" => "admins#create"

          # ツアー
          post "tours" => "tours#create"
          get "tours" => "tours#index"
          get "tours/:id" => "tour#index"
          delete "tours/:id" => "tour#destroy"

          #　管理者の名前を表示する
          get "admin_name_show" => "admins#index"
        end
    end

    # フロント表示用
    get "*not_found" => "front#index"
end

Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          # セッション
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"

          # アカウント
          post "guides" => "guides#create"
          get "admins/me" => "admins#index"
          post "admins" => "admins#create"
          get "accounts" => "accounts#index"
          delete "guides/:id" => "guides#delete"
          delete "admins/:id" => "admins#delete"
          get "guides/:token/schedules" => "guides#index"
          patch "guides/:token/update" => "guides#update"

          # ツアー
          post "tours" => "tours#create"
          get "tours" => "tours#index"
          get "tours/:id" => "tour#index"
          delete "tours/:id" => "tour#destroy"
          

          # 担当ガイド
          post "tours/:id/guides" => "tour_guides#create"
          delete "tours/:id/guides" => "tour_guides#destroy"
        end
    end

    # フロント表示用
    get "*not_found" => "front#index"
end

Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          # セッション
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"

          # アカウント
          get "accounts" => "accounts#index"

          # 管理者
          post "admins" => "admins#create"
          patch "admins/:id" => "admins#update"
          delete "admins/:id" => "admins#delete"
          get "admins/:id" => "admins#index"
          post "password/:token" => "password#create"
          post "admins/:id/password/reset" => "password_reset#create"

          # ガイド
          post "guides" => "guides#create"
          patch "guides/:id" => "guides#update"
          delete "guides/:id" => "guides#delete"
          get "guides/:id" => "guides#index"

          # スケジュール
          get "schedules/:token" => "guide_schedules#index"
          patch "schedules/:token" => "guide_schedules#update"

          # ツアー
          post "tours" => "tours#create"
          get "tours" => "tours#index"
          get "tours/:id" => "tour#index"
          delete "tours/:id" => "tour#destroy"

          # ツアー／実績
          get "tours/:tour_id/achievements" => "tour_achievements#index"
          post "tours/:tour_id/achievements/:guide_id" => "achievements#create"

          # ツアー／担当ガイド
          post "tours/:id/guides" => "tour_guides#create"
          delete "tours/:id/guides" => "tour_guides#destroy"
          patch "tours/:tour_id/guides/:guide_id/schedules" => "tours#update"

          # テンプレート
          get "templates/:id" => "template#index"
          get "templates" => "templates#index"
          post "templates" => "templates#create"
        end
    end

    # フロント表示用
    get "*not_found" => "front#index"

    # Not Found
    post "*not_found" => "application#routing_error"
    patch "*not_found" => "application#routing_error"
    delete "*not_found" => "application#routing_error"
end

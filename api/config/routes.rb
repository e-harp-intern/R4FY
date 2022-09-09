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
          get "admins/me" => "admins#index"

          # ガイド
          post "guides" => "guides#create"
          patch "guides/:id" => "guides#update"
          delete "guides/:id" => "guides#delete"

          # スケジュール
          get "guides/:token/schedules" => "guide_schedules#index"
          patch "guides/:token/schedules" => "guide_schedules#update"

          # ツアー
          post "tours" => "tours#create"
          get "tours" => "tours#index"
          get "tours/:id" => "tour#index"
          delete "tours/:id" => "tour#destroy"

          # ツアー／実績
          post "tours/:tour_id/achievements/:guide_id" => "achievements#create"

          # ツアー／担当ガイド
          post "tours/:id/guides" => "tour_guides#create"
          delete "tours/:id/guides" => "tour_guides#destroy"

          # テンプレート
          get "templates/:id" => "templates#index"
        end
    end

    # フロント表示用
    get "*not_found" => "front#index"
end

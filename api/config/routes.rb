Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          post "tours" => "touradds#create"
          post "guides" => "guides#create"
          post "admins" => "admins#create"
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"
          get "tours" => "toursort#index"
          get "tours/detail/:id" => "tourdetail#index"
          delete "tours/:id" => "tourdetail#destroy"
        end
    end
end

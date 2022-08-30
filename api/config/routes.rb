Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"
          get "tours" => "toursort#index"
          get "tours/detail/:id" => "tourdetail#index"
        end
    end
end

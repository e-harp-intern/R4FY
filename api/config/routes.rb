Rails.application.routes.draw do

    namespace "api" do
        namespace "v1" do
          post "login" => "sessions#create"
          delete "logout" => "sessions#destroy"
        end
    end
end

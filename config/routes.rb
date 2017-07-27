Rails.application.routes.draw do
  namespace :v1 do
    resource :rates, only: :show
    resource :currency, only: :show
  end
end

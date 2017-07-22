Rails.application.routes.draw do
  get 'market_index/show'

  namespace :v1 do
    resource :rates, only: :show
  end
end

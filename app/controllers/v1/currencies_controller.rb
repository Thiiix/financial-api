module V1
  class CurrenciesController < ApplicationController
    caches_action :show, expires_in: 5.minutes

    def show
      currencies = Currency.new.all

      render json: currencies
    end
  end
end

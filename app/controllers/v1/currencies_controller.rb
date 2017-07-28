module V1
  class CurrenciesController < ApplicationController
    def show
      currencies = Currency.new.all

      expires_in 3.minutes, :public => true
      render json: currencies
    end
  end
end

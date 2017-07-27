module V1
  class CurrenciesController < ApplicationController

    def show
      currencies = Currency.new.all

      render json: currencies
    end
  end
end

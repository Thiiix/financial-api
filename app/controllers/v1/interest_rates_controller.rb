module V1
  class InterestRatesController < ApplicationController

    def show
      render json: interest_rates
    end

    private

    def interest_rates
      interest_rates = InterestRates.new

      {
        selic: interest_rates.selic,
        cdi: interest_rates.cdi
      }
    end
  end
end

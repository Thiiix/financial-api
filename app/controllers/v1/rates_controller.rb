module V1
  class RatesController < ApplicationController
    def show

      expires_in 3.minutes, :public => true
      render json: rates_result
    end

    private

    def rates_result
      rates = Rates.new

      {
        igp_m: rates.igp_m,
        ipca: rates.ipca,
        selic: rates.selic,
        cdi: rates.cdi,
      }
    end
  end
end

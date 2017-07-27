module V1
  class RatesController < ApplicationController
    caches_action :show, expires_in: 5.minutes

    def show
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

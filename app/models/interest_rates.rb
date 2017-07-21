class InterestRates
  def selic
    @selic ||= get_rate_value(4392)
  end

  def cdi
    @cdi ||= get_rate_value(1178)
  end

  private

  def get_rate_value(action)
    Rails.cache.fetch "bacen-client--interest-rates--#{action}", expires_in: 1.minute do
      result = Bacen::Client.execute(:get_ultimo_valor_xml, { codigoSerie: action })
      Nokogiri.XML(result.dig(:get_ultimo_valor_xml_response, :get_ultimo_valor_xml_return)).search('VALOR').children[0].content
    end
  end
end

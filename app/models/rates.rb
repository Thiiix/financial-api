class Rates

  PERIODICITY = {
    'd' => 'daily',
    'm' => 'monthly',
    'y' => 'yearly'
  }

  def selic
    @selic ||= get_rate_value(4392)
  end

  def cdi
    @cdi ||= get_rate_value(1178)
  end

  def igp_m
    @igp_m ||= get_rate_value(189)
  end

  def ipca
    @ipca ||= get_rate_value(433)
  end

  private

  def get_rate_value(action)
    Rails.cache.fetch "bacen-client--interest-rates--#{action}", expires_in: 60.minute do
      client_request = client_request(action)
      result = extract_data_from_result(client_request).first
      build_payload(result)
    end
  end

  def build_payload(data)
    {
      description: data['NOME'],
      code: data['CODIGO'],
      unit: data['UNIDADE'],
      date: "#{data['DATA']['ANO']}-#{data['DATA']['MES']}-#{data['DATA']['DIA']}".to_time.iso8601,
      periodicity: PERIODICITY[data['PERIODICIDADE'].downcase],
      value: data['VALOR']
    }
  end

  def extract_data_from_result(client_request)
    Hash.from_xml(Nokogiri.XML(client_request.dig(:get_ultimo_valor_xml_response, :get_ultimo_valor_xml_return)).search('SERIE').to_xml).values
  end

  def client_request(action)
    Bacen::Client.execute(:get_ultimo_valor_xml, { codigoSerie: action })
  end
end

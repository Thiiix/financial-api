class Currency
  CURRENCIES_CODES = YAML.load_file("#{Rails.root}/config/currencies_codes.yml")['currency_codes'].deep_symbolize_keys.freeze

  attr_reader :currency_code

  def initialize(currency_code: nil)
    @currency_code = currency_code
  end

  def sell
    @sell ||= get_currency_value :sell
  end

  def buy
    @buy ||= get_currency_value :buy
  end

  def available_currencies
    CURRENCIES_CODES.keys
  end

  private

  def get_currency_value(action)
    currency_code = CURRENCIES_CODES[@currency_code][action]

    result = Bacen::Client.execute(:get_ultimo_valor_xml, { codigoSerie: currency_code })
    Nokogiri.XML(result.dig(:get_ultimo_valor_xml_response, :get_ultimo_valor_xml_return)).search('VALOR').children[0].content
  end
end

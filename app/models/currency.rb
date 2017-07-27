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

  def all
    codes = []

    CURRENCIES_CODES.map do |currency|
      codes << currency[1][:sell]
      codes << currency[1][:buy]
    end

    options = {
      codigoSeries: { item: codes },
      dataInicio: 1.day.ago.strftime("%d/%m/%Y"),
      dataFim: Time.now.strftime("%d/%m/%Y")
    }

    response = Bacen::Client.execute(:get_valores_series_xml, options)

    result = Hash.from_xml(Nokogiri.XML(response.dig(:get_valores_series_xml_response, :get_valores_series_xml_return)).children.to_xml)

    build_currencies_result(result.dig("SERIES", "SERIE"))
  end

  def available_currencies
    CURRENCIES_CODES.keys
  end

  private

  def build_currencies_result(results)
    result = []

    CURRENCIES_CODES.map do |currency|
      result << create_currency_element(:sell, currency.first, find_item_from_result(results, currency.second[:sell]))
      result << create_currency_element(:buy, currency.first, find_item_from_result(results, currency.second[:buy]))
    end

    result
  end

  def find_item_from_result(results, item)
    results.select { |a| a['ID'].to_i == item }
  end

  def create_currency_element(type, currency, result)
    item = item.is_a?(Array) ? result[0]['ITEM'].last : result[0]['ITEM']

    {
      currency: currency,
      type: type,
      value: item['VALOR'].to_f,
      date: item['DATA'].to_time.iso8601
    }
  end

  def get_currency_value(action)
    currency_code = CURRENCIES_CODES[@currency_code][action]

    result = Bacen::Client.execute(:get_ultimo_valor_xml, { codigoSerie: currency_code })
    Nokogiri.XML(result.dig(:get_ultimo_valor_xml_response, :get_ultimo_valor_xml_return)).search('VALOR').children[0].content
  end
end

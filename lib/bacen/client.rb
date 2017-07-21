# API Methods
#
# getUltimoValorXML:
# Get the last value of a series and returns the result in XML format.
# Parameters:
# - long codigoSerie (code of the series)
# Return:
# - String (string containing the result of the search in XML format)
#
# getValor:
# Get the value of series in a given date (dd/MM/yyyy).
# Parameters:
# - long codigoSerie (code of the series)
# - String data (the target date in format “dd/MM/yyyy”)
# Return:
# - BigDecimal (object containing the value)
#
# getValorEspecial:
# Get the value of a special series in a given period.
# Parameters:
# - long codigoSerie (code of the series)
# - String data (the initial date in format “dd/MM/yyyy”)
# - String dataFim (the end date in format “dd/MM/yyyy”)
# Return:
# - BigDecimal (object containing the value)
#
# getValoresSeriesXML:
# Get the values of one or more series inside a given period. The result of the search is returned to the client in XML format.
# Parameters:
# - long[] codigosSeries (list/array of series codes)
# - String dataInicio (the initial date in format “dd/MM/yyyy”)
# - String dataFim (the end date in format “dd/MM/yyyy”)
# Return:
# - String (the result of the search in XML format)


module Bacen
  class Client
    require 'savon'
    class Error < StandardError; end

    SAVON_OPTIONS = YAML.load_file("#{Rails.root}/config/savon.yml")[Rails.env].freeze
    OPERATIONS = [:get_ultimo_valor_xml, :get_valor, :get_valor_especial, :get_valores_series_xml]
    DEFAULT_TIMEOUT = 30

    def self.execute(operation, options={})
      raise Error.new("The operation #{operation} is not valid") unless OPERATIONS.include?(operation)
  
      client = Savon.client(savon_options('FachadaWSSGS', ENV['BACEN_WSDL_URL'], DEFAULT_TIMEOUT))
      response = client.call(operation, message: options)

      if response.success?
        response.body
      else
        raise Error.new("Response failed")
      end

    end

    def self.savon_options(wsdl, endpoint, timeout)
      options = SAVON_OPTIONS.merge(
        wsdl: wsdl_path_for(wsdl),
        endpoint: endpoint,
        open_timeout: timeout,
        read_timeout: timeout
      )
      options
    end

    def self.wsdl_path_for(name)
      File.expand_path("../../app/wsdl/#{name}.wsdl", __dir__)
    end
  end
end

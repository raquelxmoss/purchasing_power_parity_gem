require "json"
require "httparty"

module Ppp
  class PppError < StandardError; end
  class CountryInformationNotFound < PppError; end

  class CalculatePpp
    attr_reader :fetched_at

    COUNTRY_META_API = "https://restcountries.eu/rest/v2/alpha/"
    EXCHANGE_RATES_API = "https://openexchangerates.org/api/latest.json"
    QUANDL_API = "https://www.quandl.com/api/v3/"

    def initialize(fetched_at: Time.now)
      @fetched_at = fetched_at
      @year = fetched_at.year
      @previous_year = @year - 1
    end

    def call(country)
      metadata = fetch_country_metadata(country)
      exchange_rate = exchange_rates[metadata[:currencies][0]["code"]]
      ppp = fetch_ppp(metadata[:country_code_iso_alpha_3])
      calculate_ppp_conversion_factor(ppp, exchange_rate)
    end

    private

    def fetch_country_metadata(country_code)
      response = HTTParty.get("#{COUNTRY_META_API}#{country_code}")
      metadata = JSON.parse(response.body)

      { currencies: metadata["currencies"], country_code_iso_alpha_3: metadata["alpha3Code"] }
      # TODO raise metadatanotfounderror
    rescue HTTParty::ResponseError => error
      raise PppError, error.message
    end

    def exchange_rates
      @exchange_rates ||= fetch_exchange_rates
    end

    def fetch_exchange_rates
      response = HTTParty.get("#{EXCHANGE_RATES_API}?app_id=#{Ppp.configuration.openexchangerates_api_key}")
      JSON.parse(response.body)["rates"]
    rescue HTTParty::ResponseError => error
      raise PppError, error.message
    end

    def fetch_ppp(country_code_iso_alpha_3)
      response = HTTParty.get(quandl_api_url(country_code_iso_alpha_3))
      JSON.parse(response.body)["dataset"]["data"][0][1]
    rescue HTTParty::ResponseError => error
      raise PppError, error.message
    end

    def calculate_ppp_conversion_factor(ppp, exchange_rate)
      ppp / exchange_rate
    end

    def quandl_api_url(country_code_iso_alpha_3)
      "#{QUANDL_API}datasets/ODA/#{country_code_iso_alpha_3}_PPPEX.json?start_date=#{@previous_year}-01-01&end_date=#{@year}-01-01&api_key=#{Ppp.configuration.quandl_api_key}"
    end
  end
end

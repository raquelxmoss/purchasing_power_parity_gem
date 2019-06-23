module Ppp
  class PppError < StandardError; end
  class ApiRateLimitExceeded < PppError; end
  class ApiError < PppError; end
  class CountryInformationNotFound < PppError; end

  class CalculatePpp
    COUNTRY_META_API = "https://restcountries.eu/rest/v2/alpha/"
    EXCHANGE_RATES_API = "https://openexchangerates.org/api/latest.json"
    QUANDL_API = "https://www.quandl.com/api/v3/"

    def initialize(now: Time.now)
      @now = now
      @year = now.year
      @previous_year = year - 1
    end

    def call(country)
      @country = country
      # metadata = fetch_country_metadata(country)
      # exchange_rates  = exchange_rate
      # ppp = fetch_ppp
      # conversion_factor = calculate_ppp_conversion_factor
      # {}.merge(meta, exchange_rates, ppp, conversion_factor)
    end

    private

    def fetch_country_metadata
      response = HTTParty.get("#{COUNTRY_META_API}#{@country_code}")
      {
        currencies: response.body["currencies"],
        country_code_iso_alpha_3: repsonse.body["alpha3Code"]
      }
    rescue HTTParty::WhateverError => error
      # TODO
    end

    def exchange_rate
      # const findExchangeRate = (exchangeRates, currenciesCountry) => {
      #   for (let i = 0; i < currenciesCountry.length; i++) {
      #     if (exchangeRates[currenciesCountry[i].code]) {
      #       return {
      #         exchangeRate: exchangeRates[currenciesCountry[i].code],
      #         ...currenciesCountry[i],
      #       };
      #     } else {
      #       return {
      #         exchangeRate: 1,
      #       }
      #     }
      #   }
      # };
    end

    def exchange_rates
      response = HTTParty.get("#{EXCHANGE_RATES_API}?app_id=#{Ppp.configuration.openexchangeratesApiKey}")
      # main_currency = 
      # currencyMain: findExchangeRate(response.data.rates, pppInformation.currenciesCountry),
    rescue => e
      # TODO
    end

    def fetch_ppp(country_code_iso_alpha_3)
      response = HTTParty.get(quandl_api_url(country_code_iso_alpha_3))
      # const mapToPpp = pppInformation => response =>
      #   ({
      #     ...pppInformation,
      #     ppp: response.data.dataset.data[0][1],
      #   });
    rescue => error
      #todo
    end

    def calculate_ppp_conversion_factor
      # const computePppConversionFactor = ({ currencyMain, ppp }) =>
      #   ppp / currencyMain.exchangeRate;
    end

    def quandl_api_url(country_code_iso_alpha_3)
      "#{QUANDL_API}datasets/ODA/#{country_code_iso_alpha_3}_PPPEX.json?start_date=#{@previous_year}-01-01&end_date=#{@year}-01-01&api_key=#{Ppp.configuraton.quandl_api_key}"
    end
  end
end

  #     .then(fetchCountryMeta)
  #     .then(fetchExchangedRates(openexchangeratesApiKey))
  #     .then(fetchPpp(quandlApiKey))
  #     .then(getPppConversionFactor)

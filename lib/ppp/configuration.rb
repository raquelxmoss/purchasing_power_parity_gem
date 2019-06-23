module Ppp
  class Configuration
    TEST_COUNTRIES = ["NZ", "DE"]

    attr_accessor :countries, :base_currency, :cache, :raise_on_failure,
      :outfile, :logfile, :quandl_api_key, :openexchangerates_api_key

    def initialize
      @quandl_api_key = nil
      @openexchangerates_api_key = nil

      @countries = TEST_COUNTRIES
      @base_currency = "USD"

      @cache = true
      @raise_on_failure = false
      @outfile = "ppp.json"
      @logfile = "log/ppp"
    end
  end
end

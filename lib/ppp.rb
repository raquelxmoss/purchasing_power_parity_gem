require "ppp/version"
require "ppp/configuration"
require "ppp/calculate_ppp"
require "pry"

module Ppp
  class MissingApiKey < StandardError; end
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?

    raise MissingApiKey, "Please configure your quandl api key" unless configuration.quandl_api_key
    raise MissingApiKey, "Please configure your open exchange rates api key" unless configuration.openexchangerates_api_key
  end

  def self.call(countries = configuration.countries)
    calculator = CalculatePpp.new

    {}.tap do |result|
      countries.each { |country| result[country] = calculator.call(country) }
      write_to_file(result, calculator.fetched_at) if configuration.cache
    end
  rescue Ppp::PppError => error
    log_error(error)
    raise error if configuration.raise_on_failure
  end

  def self.log_error(error)
    File.open(configuration.logfile, "a", error.inspect)
  end

  def self.write_to_file(ppp_conversion_factors, fetched_at)
    json = {
      fetched_at: fetched_at,
      ppp_conversion_factors: ppp_conversion_factors
    }

    File.open(configuration.outfile, "w", json)
  end
end

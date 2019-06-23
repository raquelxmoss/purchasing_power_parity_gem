require "ppp/version"
require "ppp/configuration"
require "ppp/calculate_ppp"

module Ppp
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
    # raise if no api keys
  end

  def self.call(now: Time.now, **options)
    countries = options.fetch(:countries, configuration.countries)
    new(options.merge(countries: countries, now: now)).call
  rescue PppError => error
    log_error
    raise error if configuration.raise_on_failure
  end

  def self.log_error(error)
  end

  def initialize(**options)
    @now = options.fetch(:now)
    @countries = options.fetch(:countries)
  end

  def call
    calculator = CalculatePpp.new(now: @now)

    {}.tap do |result|
      @countries.each { |country| result[country] = calculator.call(country) }
      write_to_file(result) if configuration.cache
    end
  end

  private

  def write_to_file(result)
    json = {
      base_currency: configuration.base_currency,
      fetched_at: @now,
      ppp_conversion_factors: result
    }

    File.open("w", configuration.outfile, json)
  end
end
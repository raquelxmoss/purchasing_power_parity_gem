require "spec_helper"

RSpec.describe Ppp do
  let(:time) { Time.now }
  let(:calculator) { instance_double(Ppp::CalculatePpp, fetched_at: time, call: 0.95) }

  describe ".configure" do
    it "has a version number" do
      expect(Ppp::VERSION).not_to be nil
    end

    it "configures itself with defaults" do
      Ppp.configure

      config = Ppp.configuration

      expect(config.base_currency).to eq("USD")
      expect(config.cache).to eq(true)
      expect(config.logfile).to eq("log/ppp")
      expect(config.outfile).to eq("ppp.json")
      expect(config.raise_on_failure).to eq(false)
    end

    it "accepts configuration overrides" do
      Ppp.configure { |config| config.cache = false }

      expect(Ppp.configuration.cache).to eq(false)
    end

    it "raises an error if the quandl_api_key is missing" do
      expect { Ppp.configure { |config| config.quandl_api_key = nil }}
        .to raise_error(Ppp::MissingApiKey, "Please configure your quandl api key")
    end

    it "raises an error if the openexchangerates_api_key is missing" do
      expect { Ppp.configure { |config| config.openexchangerates_api_key = nil }}
        .to raise_error(Ppp::MissingApiKey, "Please configure your open exchange rates api key")
    end
  end

  describe ".call" do
    before do
      allow(Ppp::CalculatePpp).to receive(:new).and_return(calculator)
    end

    it "defaults to using countries set in the configuration" do
      expect(calculator).to receive(:call).with("NZ")
      expect(calculator).to receive(:call).with("DE")

      Ppp.call
    end

    it "accepts an array of countries" do
      expect(calculator).to receive(:call).with("PL")
      expect(calculator).to receive(:call).with("HU")

      Ppp.call(["PL", "HU"])
    end

    it "writes the result to file if Configuration#cache is true" do
      Ppp.configure { |config| config.cache = true }

      expect(Ppp).to receive(:write_to_file)

      Ppp.call
    end
  end

  describe ".write_to_file" do
    before do
      Ppp.configure { |config| config.cache = true }
      allow(Ppp::CalculatePpp).to receive(:new).and_return(calculator)
    end

    it "writes to the file specified in the configuration" do
      expected_json = { fetched_at: time, ppp_conversion_factors: {"DE" => 0.95, "NZ" => 0.95} }

      expect(File).to receive(:open).with(Ppp.configuration.outfile, "w", expected_json)

      Ppp.call
    end
  end

  describe ".log_error" do
    let(:error) { Ppp::PppError.new("something bad happened") }
    before do
      Ppp.configure { |config| config.raise_on_failure = false }
      allow(Ppp::CalculatePpp).to receive(:new).and_return(calculator)
      allow(calculator).to receive(:call).and_raise(error)
    end

    it "appends to the log" do
      expect(File).to receive(:open).with(Ppp.configuration.logfile, "a", error.inspect)

      Ppp.call
    end
  end
end

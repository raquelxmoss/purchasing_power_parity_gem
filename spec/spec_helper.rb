require "bundler/setup"
require "ppp"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Ppp.configure do |ppp_config|
      ppp_config.quandl_api_key = "quandl_api_key"
      ppp_config.openexchangerates_api_key = "openexchangerates_api_key"
    end
  end
end

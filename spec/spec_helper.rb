require 'simplecov'
require 'bundler/setup'
require 'rspec/collection_matchers'
require 'rspec_command'
require 'exord'
include Exord

RSpec.configure do |config|
  config.include RSpecCommand

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Money.locale_backend = :currency
  end
end

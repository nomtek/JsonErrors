# frozen_string_literal: true

# require 'active_record/railtie'
require 'rails'
require 'action_controller/railtie'
require 'rspec/rails'
require 'json_errors'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_base_class_for_anonymous_controllers = false
end

CustomError = Class.new(StandardError)
JsonErrors.configure do |config|
  config.custom_codes = {
    custom_error: { code: 'custom_code', http_status: 418 },
    custom_error2: { code: 'custom_code2', http_status: 419 },
    test_error: { code: 'test_code', http_status: 422 }
  }
  config.error_dictionary = {
    CustomError => :custom_error2,
    StandardError => :custom_error
  }
end

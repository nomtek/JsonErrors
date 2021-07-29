# frozen_string_literal: true

require_relative 'json_errors/version'
require_relative 'json_errors/config'
require_relative 'json_errors/error'
require_relative 'json_errors/error/basic_error'
require_relative 'json_errors/error/custom_payload_error'
require_relative 'json_errors/error/validation_error'
require_relative 'json_errors/rescuer'

# Main module
module JsonErrors
  def self.configure
    yield(config)
  end

  def self.config
    Config.instance
  end
end

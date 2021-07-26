# frozen_string_literal: true

require_relative 'json_errors/version'
require_relative 'json_errors/config'
require_relative 'json_errors/application_error'
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

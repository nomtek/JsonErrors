# frozen_string_literal: true

require_relative 'json_errors/version'

# Main module
module JsonErrors
  def self.configure
    yield(config)
  end

  def self.config
    Config.instance
  end
end

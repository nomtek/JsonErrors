# frozen_string_literal: true

require 'singleton'

module JsonErrors
  # Main config class. It brings all the customizable params.
  class Config
    include Singleton

    attr_accessor :error_dictionary, :custom_codes

    def self.missing_config_error_meesage
      <<~'MSG'
        Configuration is missing. Run the generattor: `bundle exec rails g json_errors::install`
        or create the initializer yourself.
        Check out the README https://github.com/nomtek/JsonErrors/blob/main/README.md
      MSG
    end
  end
end

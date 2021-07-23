# frozen_string_literal: true

require 'singleton'

module JsonErrors
  class Config
    include Singleton

    attr_accessor :response_body, :error_dictionary, :custom_codes
  end
end

# frozen_string_literal: true

module JsonErrors
  # Main error class to be rescued from
  class BasicError < StandardError
    attr_reader :code

    def initialize(msg, name)
      raise 'Wrong name' unless name.in?(codes.keys)

      @code = codes[name][:code]
      @name = name
      super(msg)
    end

    def self.codes
      JsonErrors.config.custom_codes
    end

    def to_json(_options = nil)
      {
        code: code,
        message: to_s
      }.to_json
    end

    def http_status
      codes[name][:http_status]
    end

    private

    attr_reader :name

    def codes
      self.class.codes
    end
  end
end

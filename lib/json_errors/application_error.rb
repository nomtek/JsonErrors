# frozen_string_literal: true

module JsonErrors
  # Main error class to be rescued from
  class ApplicationError < StandardError
    attr_reader :code, :payload

    def initialize(msg, name, payload = [])
      raise 'Wrong name' unless name.in?(codes.keys)

      @code = codes[name][:code]
      @name = name
      @payload = payload
      super(msg)
    end

    def self.method_missing(name, *args)
      error = args.first
      return super if error.nil?
      return super unless name.in?(codes.keys)
      return new(error.to_s, name) unless error.respond_to?(:record)

      validation_payload = []
      error.record.errors.each do |key, messages|
        validation_payload << { key => messages }
      end
      new(error.to_s, name, validation_payload)
    end

    def self.respond_to_missing?(name, _respond_to_private = false)
      name.in?(codes.keys) || super
    end

    def self.codes
      JsonErrors.config.custom_codes
    end

    def to_json(_options = nil)
      {
        code: code,
        message: message,
        payload: payload
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

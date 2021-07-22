# frozen_string_literal: true

module JsonErrors
  # Main error class to be rescued from
  class ApplicationError < StandardError
    DEFAULT_CODE = 1000
    CODES = {
      internal_server_error: { code: 1000, http_status: 500 },
      general_error: { code: 1001, http_status: 500 },
      not_found: { code: 1002, http_status: 404 },
      database_error: { code: 1003, http_status: 500 },
      parameter_missing: { code: 1010, http_status: 400 },
      validation_failed: { code: 1020, http_status: 422 }
    }.freeze

    attr_reader :code, :payload

    def initialize(msg, name = nil, payload = [])
      name = :general_error unless name.in?(CODES.keys)
      @code = CODES[name][:code]
      @name = name
      @payload = payload
      super(msg)
    end

    def self.method_missing(name, error)
      return super unless name.in?(CODES.keys)
      return new(error.to_s, name) unless error.respond_to?(:record)

      validation_payload = []
      error.record.errors.each do |key, messages|
        validation_payload << { key => messages }
      end
      new(error.to_s, name, validation_payload)
    end

    def self.respond_to_missing?(name, _respond_to_private = false)
      name.in?(CODES.keys) || super
    end

    def to_json(_options)
      {
        code: code,
        message: message,
        payload: payload
      }.to_json
    end

    def http_status
      CODES[name][:http_status]
    end

    private

    attr_reader :name
  end
end

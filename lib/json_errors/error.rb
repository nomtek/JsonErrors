# frozen_string_literal: true

module JsonErrors
  # Error facade
  class Error
    def self.method_missing(name, *args)
      message, payload = args
      return super unless name.in?(codes.keys)
      return ValidationError.new(message, name, payload&.record) if codes[name][:validation_errors] == :active_record
      return BasicError.new(message, name) if payload.nil?

      CustomPayloadError.new(message, name, payload)
    end

    def self.respond_to_missing?(name, _respond_to_private = false)
      name.in?(codes.keys) || super
    end

    def self.codes
      JsonErrors.config.custom_codes
    end
  end
end

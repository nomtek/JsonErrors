# frozen_string_literal: true

module JsonErrors
  # Error class for custom payload errors
  class CustomPayloadError < BasicError
    attr_accessor :payload

    def initialize(msg, name, payload)
      @payload = payload
      super(msg, name)
    end

    def to_json(_options = nil)
      {
        code: code,
        message: message,
        payload: payload
      }.to_json
    end
  end
end

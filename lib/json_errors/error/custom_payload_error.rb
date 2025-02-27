# frozen_string_literal: true

module JsonErrors
  # Error class for custom payload errors
  class CustomPayloadError < BasicError
    attr_accessor :payload

    def initialize(msg, name, payload)
      super(msg, name)
      @payload = payload
    end

    def to_json(_options = nil)
      {
        code: code,
        message: to_s,
        payload: payload
      }.to_json
    end
  end
end

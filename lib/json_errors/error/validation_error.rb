# frozen_string_literal: true

module JsonErrors
  # Error class for custom payload errors
  class ValidationError < BasicError
    def initialize(msg, name, record)
      raise 'Wrong record' unless record.respond_to?(:errors)

      @record = record
      super(msg, name)
    end

    def to_json(_options = nil)
      {
        code: code,
        message: message,
        payload: payload
      }.to_json
    end

    private

    attr_reader :record

    def payload
      validation_payload = []
      record.errors.each do |key, messages|
        validation_payload << { key => messages }
      end

      { object.class.to_s => validation_payload }
    end
  end
end

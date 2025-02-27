# frozen_string_literal: true

module JsonErrors
  # Error class for custom payload errors
  class ValidationError < BasicError
    def initialize(msg, name, record)
      super(msg, name)
      raise 'Wrong record' unless record.respond_to?(:errors)

      @record = record
    end

    def to_json(_options = nil)
      {
        code: code,
        message: to_s,
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

      { record.class.to_s => validation_payload }
    end
  end
end

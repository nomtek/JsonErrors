# frozen_string_literal: true

module JsonErrors
  # Error class for custom payload errors
  class ValidationError < BasicError
    def initialize(msg, name, model_instance)
      super(msg, name)
      raise 'Wrong record' unless model_instance.respond_to?(:errors)

      @model_instance = model_instance
    end

    def to_json(_options = nil)
      {
        code: code,
        message: to_s,
        payload: payload
      }.to_json
    end

    private

    attr_reader :model_instance

    def payload
      validation_payload = model_instance.errors.map do |error|
        {
          'object' => model_instance.class.to_s,
          'attribute' => error.attribute,
          'error_type' => error.type,
          'message' => error.full_message
        }
      end

      { 'validation_errors' => validation_payload }
    end
  end
end

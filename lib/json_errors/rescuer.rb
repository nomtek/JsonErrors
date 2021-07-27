# frozen_string_literal: true

require 'active_support'

module JsonErrors
  # Main concern module to be included to the controller
  module Rescuer
    extend ActiveSupport::Concern

    included do
      error_dictionary = JsonErrors.config.error_dictionary
      raise JsonErrors::Config.missing_config_error_meesage if error_dictionary.blank?
      raise JsonErrors::Config.missing_config_error_meesage if JsonErrors.config.custom_codes.blank?

      error_dictionary.keys.reverse.each do |error_class|
        rescue_from error_class do |error|
          log_error(error)
          render_error ApplicationError.send(error_dictionary[error_class], error)
        end
      end

      rescue_from ApplicationError do |error|
        log_error(error)
        render_error(error)
      end
    end

    def render_error(error)
      render json: error, status: error.http_status
    end

    def log_error(error)
      Rails.logger.error "#{error.class}: #{error}"
      Rails.logger.debug error.backtrace.join("\n")
    end
  end
end

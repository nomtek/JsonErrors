# frozen_string_literal: true

require 'active_support'

module JsonErrors
  # Main concern module to be included to the controller
  module Rescuer
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |error|
        log_error(error)
        render_error ApplicationError.general_error(error)
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
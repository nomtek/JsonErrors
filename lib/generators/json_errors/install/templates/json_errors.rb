# frozen_string_literal: true

JsonErrors.configure do |config|
  config.custom_codes = {
    # general_error: { code: 1001, http_status: 500 },
    not_found: { code: 1002, http_status: 404 },
    database_error: { code: 1003, http_status: 500 },
    parameter_missing: { code: 1010, http_status: 400 },
    validation_failed: { code: 1020, http_status: 422, validation_errors: :active_record },
    internal_server_error: { code: 1000, http_status: 500 }
  }

  config.error_dictionary = {
    # Uncomment or comment the following lines according to needs.
    # They are caught and rescued in a cascade manner top to bottom.

    ActiveRecord::RecordInvalid => :validation_failed,
    ActionController::ParameterMissing => :parameter_missing,
    ActiveRecord::RecordNotFound => :not_found,
    ActiveRecord::ActiveRecordError => :database_error,
    StandardError => :internal_server_error
  }
end

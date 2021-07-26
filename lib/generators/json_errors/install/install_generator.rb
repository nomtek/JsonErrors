# frozen_string_literal: true

require 'rails/generators'

module JsonErrors
  module Generators
    # Main generator class
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_initializer_file
        copy_file 'json_errors.rb', 'config/initializers/json_errors.rb'
      end
    end
  end
end

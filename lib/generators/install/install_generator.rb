# frozen_string_literal: true

module JsonErrors
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)
  end
end

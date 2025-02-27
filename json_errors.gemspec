# frozen_string_literal: true

require_relative 'lib/json_errors/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_errors'
  spec.version       = JsonErrors::VERSION
  spec.authors       = ['Łukasz Pająk', 'Nomtek']
  spec.email         = ['l.pajak@nomtek.com']

  spec.summary       = 'RoR JSON API errors handling gem'
  spec.description   = 'Ruby on Rails gem for handling errors in the JSON API'
  spec.homepage      = 'https://github.com/nomtek/JsonErrors'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/nomtek/JsonErrors'
  spec.metadata['changelog_uri'] = 'https://github.com/nomtek/JsonErrors/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 8.0.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

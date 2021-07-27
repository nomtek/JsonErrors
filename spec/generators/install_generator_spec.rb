# frozen_string_literal: true

require 'spec_helper'
require 'generators/json_errors/install/install_generator'

RSpec.describe JsonErrors::Generators::InstallGenerator do
  subject(:generator) { described_class.new }

  describe '#create_initializer_file' do
    it 'copies initializer file' do
      expect(generator).to receive(:copy_file).with('json_errors.rb', 'config/initializers/json_errors.rb')
      generator.create_initializer_file
    end
  end
end

# frozen_string_literal: true

require 'json_errors/config'

RSpec.describe JsonErrors do
  it 'has a version number' do
    expect(JsonErrors::VERSION).not_to be_nil
  end

  describe '#config' do
    it 'returns proper config object' do
      expect(described_class.config).to eq(JsonErrors::Config.instance)
    end
  end

  describe '#configure' do
    around do |example|
      old_codes = config.custom_codes
      old_error_dictionary = config.error_dictionary
      example.run
      config.custom_codes = old_codes
      config.error_dictionary = old_error_dictionary
    end

    let(:config) { JsonErrors::Config.instance }

    it 'sets up the custom codes' do
      expect do
        described_class.configure do |conf|
          conf.custom_codes = :test
        end
      end.to change(config, :custom_codes).to(:test)
    end

    it 'sets up the error dictionary' do
      expect do
        described_class.configure do |conf|
          conf.error_dictionary = :test
        end
      end.to change(config, :error_dictionary).to(:test)
    end
  end
end

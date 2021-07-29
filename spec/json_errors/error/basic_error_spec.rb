# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/error/basic_error'

RSpec.describe JsonErrors::BasicError do
  describe 'initializer' do
    context 'when name is not registered' do
      it 'raises error when wrong name is given' do
        expect { described_class.new('a', :b) }.to raise_error(RuntimeError, 'Wrong name')
      end
    end

    context 'when name is registered' do
      subject(:error) { described_class.new('Test message', :test_error) }

      it 'creates new object' do
        expect(error).to be_a(JsonErrors::BasicError)
      end

      it 'assigns proper message' do
        expect(error.message).to eq('Test message')
      end

      it 'assigns proper code' do
        expect(error.code).to eq('test_code')
      end
    end
  end

  describe '.codes' do
    it 'returns codes from config' do
      expect(described_class.codes).to eq(JsonErrors.config.custom_codes)
    end
  end

  describe '#http_status' do
    subject(:error) { described_class.new('Test message', :test_error) }

    it 'returns proper http_status' do
      expect(error.http_status).to eq(422)
    end
  end

  describe '#to_json' do
    subject(:error) { described_class.new('To json message', :custom_error) }
    let(:expected_json) do
      {
        code: 'custom_code',
        message: 'To json message'
      }.to_json
    end

    it 'returns properly formatted json' do
      expect(error.to_json).to eq(expected_json)
    end
  end
end

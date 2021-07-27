# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/application_error'

RSpec.describe JsonErrors::ApplicationError do
  it 'responds to registered errors' do
    expect(described_class).to respond_to(:custom_error)
    expect(described_class).to respond_to(:custom_error2)
    expect(described_class).to respond_to(:test_error)
  end

  describe 'initializer' do
    context 'when name is not registered' do
      it 'raises error when wrong name is given' do
        expect { described_class.new('a', :b) }.to raise_error(RuntimeError, 'Wrong name')
      end
    end

    context 'when name is registered' do
      subject(:error) { described_class.new('Test message', :test_error) }

      it 'creates new object' do
        expect(error).to be_a(JsonErrors::ApplicationError)
      end

      it 'assigns proper message' do
        expect(error.message).to eq('Test message')
      end

      it 'assigns proper code' do
        expect(error.code).to eq('test_code')
      end
    end
  end

  describe '.method_missing' do
    context 'when name is not registered' do
      it 'raises not method error' do
        expect { described_class.not_registered_name }.to raise_error(NoMethodError)
      end
    end

    context 'when method is registered' do
      subject(:error) { described_class.custom_error('Given test message') }

      it 'creates new object' do
        expect(error).to be_a(JsonErrors::ApplicationError)
      end

      it 'assigns proper message' do
        expect(error.message).to eq('Given test message')
      end

      it 'assigns proper code' do
        expect(error.code).to eq('custom_code')
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
    subject(:error) { described_class.custom_error('To json message') }
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

# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/error'

RSpec.describe JsonErrors::Error do
  it 'responds to registered errors' do
    expect(described_class).to respond_to(:custom_error)
    expect(described_class).to respond_to(:custom_error2)
    expect(described_class).to respond_to(:test_error)
  end

  describe '.method_missing' do
    context 'when name is not registered' do
      it 'raises not method error' do
        expect { described_class.not_registered_name }.to raise_error(NoMethodError)
      end
    end

    context 'when method is registered' do
      context 'without payload' do
        subject(:error) { described_class.custom_error('Given test message') }

        it 'creates new object' do
          expect(error).to be_a(JsonErrors::BasicError)
        end

        it 'assigns proper message' do
          expect(error.message).to eq('Given test message')
        end

        it 'assigns proper code' do
          expect(error.code).to eq('custom_code')
        end
      end

      context 'with custom payload' do
        subject(:error) { described_class.custom_error('Given test message', ['foo']) }

        it 'creates new object' do
          expect(error).to be_a(JsonErrors::CustomPayloadError)
        end

        it 'assigns proper message' do
          expect(error.message).to eq('Given test message')
        end

        it 'assigns proper code' do
          expect(error.code).to eq('custom_code')
        end

        it 'assigns proper payload' do
          expect(error.payload).to eq(['foo'])
        end
      end

      context 'with invalid record' do
        subject(:error) { described_class.validation_error('Validation error message', payload) }

        let(:payload) { double('StandardError', record: record) }
        let(:record) { double('TestModel', errors: { foo: :bar }) }

        it 'creates new object' do
          expect(error).to be_a(JsonErrors::ValidationError)
        end

        it 'assigns proper message' do
          expect(error.message).to eq('Validation error message')
        end

        it 'assigns proper code' do
          expect(error.code).to eq('validation_error')
        end
      end
    end
  end

  describe '.codes' do
    it 'returns codes from config' do
      expect(described_class.codes).to eq(JsonErrors.config.custom_codes)
    end
  end
end

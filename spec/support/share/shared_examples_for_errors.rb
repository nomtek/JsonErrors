# frozen_string_literal: true

RSpec.shared_examples 'a basic error' do
  describe 'initializer' do
    context 'when name is registered' do
      it 'assigns proper message' do
        expect(error.message).to eq('To json message')
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
    it 'returns proper http_status' do
      expect(error.http_status).to eq(418)
    end
  end
end

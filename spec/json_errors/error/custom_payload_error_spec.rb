# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/error/basic_error'

RSpec.describe JsonErrors::CustomPayloadError do
  subject(:error) { described_class.new('To json message', :custom_error, payload) }
  let(:payload) { { foo: :bar } }
  it_behaves_like 'a basic error'

  context 'when name is not registered' do
    it 'raises error when wrong name is given' do
      expect { described_class.new('a', :b, payload) }.to raise_error(RuntimeError, 'Wrong name')
    end
  end

  describe '#to_json' do
    let(:expected_json) do
      {
        code: 'custom_code',
        message: 'To json message',
        payload: payload
      }.to_json
    end

    it 'assigns payload correctly' do
      expect(error.payload).to eq(payload)
    end

    it 'returns properly formatted json' do
      expect(error.to_json).to eq(expected_json)
    end
  end
end

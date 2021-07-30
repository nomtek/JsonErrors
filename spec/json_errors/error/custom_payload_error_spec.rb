# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/error/basic_error'

RSpec.describe JsonErrors::CustomPayloadError do
  it_behaves_like 'a basic error'

  describe '#to_json' do
    subject(:error) { described_class.new('To json message', :custom_error, foo: :bar) }
    let(:expected_json) do
      {
        code: 'custom_code',
        message: 'To json message',
        payload: { foo: :bar }
      }.to_json
    end

    it 'assigns payload correctly' do
      expect(error.payload).to eq(foo: :bar)
    end

    it 'returns properly formatted json' do
      expect(error.to_json).to eq(expected_json)
    end
  end
end

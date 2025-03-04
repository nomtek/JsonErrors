# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/error/basic_error'

RSpec.describe JsonErrors::ValidationError do
  subject(:error) { described_class.new('To json message', :custom_error, record) }

  let(:record) { double('TestModel', errors: [double({ attribute: 'foo', full_message: 'bar', type: 'baz' })]) }

  it_behaves_like 'a basic error'

  context 'when name is not registered' do
    it 'raises error when wrong name is given' do
      expect { described_class.new('a', :b, record) }.to raise_error(RuntimeError, 'Wrong name')
    end
  end

  describe '#to_json' do
    let(:expected_json) do
      {
        code: 'custom_code',
        message: 'To json message',
        payload: {
          'validation_errors' => [
            {
              'object' => 'RSpec::Mocks::Double',
              'attribute' => 'foo',
              'error_type' => 'baz',
              'message' => 'bar'
            }
          ]
        }
      }.to_json
    end

    it 'returns properly formatted json' do
      expect(error.to_json).to eq(expected_json)
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'

RSpec.describe JsonErrors::Config do
  subject { described_class.instance }

  it { is_expected.to respond_to(:error_dictionary) }
  it { is_expected.to respond_to(:custom_codes) }
  it { is_expected.to respond_to(:error_dictionary=) }
  it { is_expected.to respond_to(:custom_codes=) }

  describe 'initializer' do
    it 'has private initializer' do
      expect { described_class.new }.to raise_error(NoMethodError, /private method 'new' called/)
    end
  end
end

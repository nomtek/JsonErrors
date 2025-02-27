# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/rescuer'
require 'json_errors/error/basic_error'

Application = Class.new(Rails::Application)
Rails.application = Application
Rails.logger = ActiveSupport::Logger.new(nil)

RSpec.describe JsonErrors::Rescuer, type: :controller do
  controller do
    include JsonErrors::Rescuer

    def index
      raise StandardError, 'Error message'
    end

    def index2
      raise CustomError, 'Custom message'
    end

    def index3
      raise JsonErrors::Error.test_error('Test message')
    end
  end

  let(:expected_response) do
    {
      code: 'custom_code',
      message: 'Error message'
    }
  end

  it 'responds with proper http code' do
    routes.draw { get 'index' => 'anonymous#index' }
    get :index
    expect(response.code).to eq('418')
  end

  it 'responds with proper json body' do
    routes.draw { get 'index' => 'anonymous#index' }
    get :index
    expect(response.body).to eq(expected_response.to_json)
  end

  context 'with custom error that inherits from StandardError' do
    context 'when custom error is raised' do
      let(:expected_response) do
        {
          code: 'custom_code2',
          message: 'Custom message'
        }
      end

      it 'responds with proper http code' do
        routes.draw { get 'index2' => 'anonymous#index2' }
        get :index2
        expect(response.code).to eq('419')
      end

      it 'responds with proper json body' do
        routes.draw { get 'index2' => 'anonymous#index2' }
        get :index2
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'when the error is raised by label' do
      let(:expected_response) do
        {
          code: 'test_code',
          message: 'Test message'
        }
      end

      it 'responds with proper http code' do
        routes.draw { get 'index3' => 'anonymous#index3' }
        get :index3
        expect(response.code).to eq('422')
      end

      it 'responds with proper json body' do
        routes.draw { get 'index3' => 'anonymous#index3' }
        get :index3
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  context 'when configuration is missing' do
    let(:config) { JsonErrors::Config.instance }

    context 'when error dictionary is missing' do
      around do |example|
        old_error_dictionary = config.error_dictionary
        config.error_dictionary = {}
        example.run
        config.error_dictionary = old_error_dictionary
      end

      it 'raises error' do
        dummy_class = class_double('DummyClass')
        expect do
          dummy_class.include(described_class)
        end.to raise_error(RuntimeError, JsonErrors::Config.missing_config_error_meesage)
      end
    end

    context 'when custom codes are missing' do
      around do |example|
        old_custom_codes = config.custom_codes
        config.custom_codes = {}
        example.run
        config.custom_codes = old_custom_codes
      end

      it 'raises error' do
        dummy_class = class_double('DummyClass')
        expect do
          dummy_class.include(described_class)
        end.to raise_error(RuntimeError, JsonErrors::Config.missing_config_error_meesage)
      end
    end
  end
end

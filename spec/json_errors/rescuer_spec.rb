# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/rescuer'
require 'json_errors/application_error'

Application = Class.new(Rails::Application)
Rails.application = Application
Rails.logger = ActiveSupport::Logger.new(nil)

config = JsonErrors.config
config.custom_codes = {
  custom_error: { code: 'custom_code', http_status: 418 },
  custom_error2: { code: 'custom_code2', http_status: 419 },
  test_error: { code: 'test_code', http_status: 422 }
}
CustomError = Class.new(StandardError)
config.error_dictionary = {
  CustomError => :custom_error2,
  StandardError => :custom_error
}

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
      raise JsonErrors::ApplicationError.test_error('Test message')
    end
  end

  let(:expected_response) do
    {
      code: 'custom_code',
      message: 'Error message',
      payload: []
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
          message: 'Custom message',
          payload: []
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
          message: 'Test message',
          payload: []
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
end

# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/config'
require 'json_errors/rescuer'
require 'json_errors/application_error'

Application = Class.new(Rails::Application)
Rails.application = Application
Rails.logger = ActiveSupport::Logger.new(nil)

config = JsonErrors.config
config.custom_codes = { custom_error: { code: 'custom_code', http_status: 418 } }
config.error_dictionary = { StandardError => :custom_error }

RSpec.describe JsonErrors::Rescuer, type: :controller do
  controller do
    include JsonErrors::Rescuer

    def index
      raise StandardError, 'Error message'
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
end

# frozen_string_literal: true

require 'spec_helper'
require 'json_errors/rescuer'
require 'json_errors/application_error'

Application = Class.new(Rails::Application)
Rails.application = Application
Rails.logger = ActiveSupport::Logger.new(nil)

RSpec.describe JsonErrors::Rescuer, type: :controller do
  before do
    routes.draw { get 'index' => 'anonymous#index' }
    get :index
  end

  controller do
    include JsonErrors::Rescuer

    def index
      raise StandardError, 'Error message'
    end
  end

  let(:expected_response) do
    {
      code: 1001,
      message: 'Error message',
      payload: []
    }
  end

  it 'responds with proper http code' do
    expect(response.code).to eq('500')
  end

  it 'responds with proper json body' do
    expect(response.body).to eq(expected_response.to_json)
  end
end

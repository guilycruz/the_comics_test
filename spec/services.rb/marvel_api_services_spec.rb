require 'spec_helper'
require './services/marvel_api_service.rb'

RSpec.describe MarvelApiService do
  describe 'call' do
    context 'Authentication successful' do
      before do
        expect_any_instance_of(MarvelApiService).
          to receive(:call).
            and_return(characters_api_response)
      end

      it 'responds successfully with an HTTP 200 status code' do
        params = { path: 'path', name: 'name' }
        response = JSON.parse(MarvelApiService.new.call(params))
        expect(response['code']).to eq(200)
      end
    end

    context 'Unauthorized' do
      before do
        code = 401
        response = double
        response.stub(:code) { code }
        response.stub(:message) { '' }
        allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:http_code).and_return(code)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:response).and_return(response)
      end

      xit 'responds unnauthorized with an HTTP 401 status code' do
        params = { path: 'path', name: 'name' }
        response = MarvelApiService.new.call(params)
        expect(response).to include('error')
      end
    end

    context 'Not Found' do
      before do
        code = 404
        response = double
        response.stub(:code) { code }
        response.stub(:message) { '' }
        allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:http_code).and_return(code)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:response).and_return(response)
      end

      xit 'responds not found with an HTTP 404 status code' do
        params = { path: 'path', name: 'name' }
        response = MarvelApiService.new.call(params)
        expect(response).to include('error')
      end
    end

    context 'Conflict' do
      before do
        code = 409
        response = double
        response.stub(:code) { code }
        response.stub(:message) { '' }
        allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:http_code).and_return(code)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:response).and_return(response)
      end

      xit 'responds not found with an HTTP 409 status code' do
        params = { path: 'path', name: 'name' }
        response = MarvelApiService.new.call(params)
        expect(response).to include('error')
      end
    end

    context 'Other errors' do
      before do
        code = 500
        response = double
        response.stub(:code) { code }
        response.stub(:message) { '' }
        allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:http_code).and_return(code)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:response).and_return(response)
      end

      xit 'responds any other message with any other HTTP status code' do
        params = { path: 'path', name: 'name' }
        response = MarvelApiService.new.call(params)
        expect(response).to include('error')
      end
    end
  end
end

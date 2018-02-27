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

    context 'Errors'do
      let(:response) { double('response', code: code, message: '') }
      let(:params) {
        {
          path: 'path',
          name: 'name'
        }
      }
      subject(:call) { MarvelApiService.new.call(params) }

      before do
        allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:http_code).and_return(code)
        allow_any_instance_of(RestClient::ExceptionWithResponse).to receive(:response).and_return(response)
      end

      context 'Unauthorized' do
        let(:code) { 401 }

        it 'responds unnauthorized with an HTTP 401 status code' do
          expect(call).to include('error')
        end
      end

      context 'Not Found' do
        let(:code) { 404 }

        it 'responds not found with an HTTP 404 status code' do
          expect(call).to include('error')
        end
      end

      context 'Conflict' do
        let(:code) { 409 }

        it 'responds not found with an HTTP 409 status code' do
          expect(call).to include('error')
        end
      end

      context 'Other errors' do
        let(:code) { 500 }

        it 'responds any other message with any other HTTP status code' do
          expect(call).to include('error')
        end
      end
    end
  end
end

require "spec_helper"
require './app.rb'

describe 'The Commics Test App' do
  def app
    App.new
  end

  describe '/characters' do
    let(:name) { nil }
    context 'without informing any "name"' do
      before {
        expect_any_instance_of(MarvelApiService).
          to receive(:call).
            and_return(characters_api_response)
      }
      subject(:get_characters) { get "/characters/#{name}"}

      it 'reponds with OK' do
        get_characters
        expect(last_response.status).to eq(200)
      end
    end
  end
end

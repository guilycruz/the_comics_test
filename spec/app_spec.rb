require "spec_helper"
require './app.rb'

describe 'The Commics Test App' do
  include Rack::Test::Methods

  def app
    App.new
  end

  it "displays home page" do
    get '/'

    expect(last_response.body).to include("Hello world!")
  end

  describe '/characters' do
    let(:name) { nil }
    context 'without informing any "name"' do
      subject(:get_characters) { get "/characters/#{name}"}

      xit 'a list of characters' do
        get_characters
        expect(last_response.body).to include("Spider-man")
        expect(last_response.body).to include("Hulk")
      end
    end
  end
end

require 'sinatra/base'
require './entities/character.rb'

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  get '/characters/?:name?' do
    name = params[:name]
    if name
      @characters = Character.find_by_name(name)
      if @characters.any?
        stories = @characters.first.stories
        random_story_with_description = stories.select { |cs| cs.description != "" }.sample
        @random_story = random_story_with_description ? random_story_with_description : stories.sample
        @story_characters = @random_story.characters
      end
      erb :characters_details
    else
      @characters = Character.all
      erb :characters
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

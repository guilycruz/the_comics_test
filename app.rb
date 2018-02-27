require 'sinatra/base'
require 'sinatra/config_file'
require './entities/character.rb'

class App < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config.yml'

  get '/characters/?:name?' do
    name = params[:name]
    if name
      @characters = Character.find_by_name(name)
      if @characters.any?
        stories = @characters.first.stories
        random_story_with_description = stories.select { |cs| cs.description != "" }.sample
        @random_story = random_story_with_description ? random_story_with_description : stories.sample
        @story_characters = @random_story.characters if @random_story
      end
      erb :characters_details, layout: :layout
    else
      @characters = Character.all(page: params[:page])
      erb :characters, layout: :layout
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

require 'sinatra/base'
require './entities/character.rb'

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  get '/characters/?:name?' do
    # if params[:user].nil?
    #    redirect '/'
    # else
    #    @user = params[:user]
    #    erb :welcome_user
    # end
    name = params[:name]
    if name
      @characters = Character.find_by_name(name)
    else
      @characters = Character.all
    end
    @susto = "XAXHUAXHUAHXUXH"
    erb :characters
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
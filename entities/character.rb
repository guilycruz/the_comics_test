require 'json'
require './services/marvel_api_service.rb'

class Character
  # include Concern::Marvelable
  attr_accessor :id, :name, :description, :resource_uri, :thumbnail, :stories

  def initialize(params={})
    self.id = params['id']
    self.name = params['name']
    self.description = params['description']
    thumbnail = params['thumbnail']
    self.thumbnail = "#{thumbnail['path']}.#{thumbnail['extension']}" if thumbnail
    self.resource_uri = params['resourceURI']
  end

  class << self
    def all
      do_call
    end

    def find_by_name(name)
      do_call(name: name)
    end

  private
    def do_call(args={})
      path = "#{self.name.downcase}s"
      params = { path: path }.merge(args)
      data = JSON.parse(MarvelApiService.new.call(params))['data']
      results = data['results']
      characters = results.map { |c| Character.new(c) }
    end
  end
end

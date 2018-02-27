require 'json'
require 'open-uri'
require './services/marvel_api_service.rb'
require './entities/concern/marvelable.rb'
require './entities/story.rb'

class Character
  include Concern::Marvelable
  attr_accessor :id, :name, :description, :resource_uri, :thumbnail

  STORIES_LIMIT = 15

  def initialize(params={})
    self.id = params['id']
    self.name = params['name']
    self.description = params['description']
    thumbnail = params['thumbnail']
    self.thumbnail = "#{thumbnail['path']}.#{thumbnail['extension']}" if thumbnail
    self.resource_uri = params['resourceURI']
  end

  def stories
    get_stories(id: self.id)
  end

  class << self
    def all
      get_characters
    end

    def find_by_name(name)
      get_characters(name: name)
    end

  private
    def get_characters(args={})
      do_call(args)
    end
  end

private
  def get_stories(args={})
    args.merge!(limit: STORIES_LIMIT, nested: Story)
    Character.do_call(args)
  end
end

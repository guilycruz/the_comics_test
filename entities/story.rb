require 'json'
require './services/marvel_api_service.rb'
require './entities/concern/marvelable.rb'

class Story
  include Concern::Marvelable
  attr_accessor :id, :name, :description, :resource_uri, :thumbnail
  PLURAL = 'stories'
  CHARACTERS_LIMIT = 25

  def initialize(params={})
    self.id = params['id']
    self.name = params['title']
    self.description = params['description']
    thumbnail = params['thumbnail']
    self.thumbnail = "#{thumbnail['path']}.#{thumbnail['extension']}" if thumbnail
    self.resource_uri = params['resourceURI']
    characters = params['characters']
  end

  def characters
    get_characters(id: self.id)
  end

  class << self
    def find_by_character(id)
      get_stories(id: id)
    end

    def plural
      PLURAL
    end

  private
    def get_stories(args={})
      do_call(args)
    end
  end

private
  def get_characters(args={})
    args.merge!(limit: CHARACTERS_LIMIT, nested: Character)
    Story.do_call(args)
  end
end

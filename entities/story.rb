require 'json'
require './services/marvel_api_service.rb'
require './entities/concern/marvelable.rb'

class Story
  include Concern::Marvelable
  attr_accessor :id, :name, :description, :resource_uri, :thumbnail, :characters
  PLURAL = 'stories'

  def initialize(params={})
    self.id = params['id']
    self.name = params['name']
    self.description = params['description']
    thumbnail = params['thumbnail']
    self.thumbnail = "#{thumbnail['path']}.#{thumbnail['extension']}" if thumbnail
    self.resource_uri = params['resourceURI']
    characters = params['characters']
    self.characters = Character.from_json(characters['items']) if characters
    # puts "CHARACTERS ITEMS: #{self.characters}"
  end

  def get_details
    story = Story.find_by_id(self.id).first
    self.description = story.description
    self.thumbnail = story.thumbnail
    self.characters = story.characters
    self
  end

  class << self
    def all
      get_stories
    end

    def find_by_id(id)
      get_stories(id: id)
    end

    def find_by_character(id)
      get_stories(id: id)
    end

    def plural
      PLURAL
    end

    def from_json(character_stories)
      character_stories.map do |story|
        resource_uri = story['resourceURI']
        if resource_uri
          id = resource_uri.split('/').last
          story.merge!('id' => id)
        end
        self.new(story)
      end
    end

  private
    def get_stories(args={})
      do_call(args)
    end
  end
end

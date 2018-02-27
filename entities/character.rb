require 'json'
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
    #stories = params['stories']
    #self.stories = Story.from_json(stories['items']) if stories
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

    def from_json(stories_character)
      stories_character.map do |character|
        resource_uri = character['resourceURI']
        # puts "URL: #{resource_uri}"
        if resource_uri
          id = resource_uri.split('/').last
          character.merge!('id' => id)
        end
        self.new(character)
      end
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

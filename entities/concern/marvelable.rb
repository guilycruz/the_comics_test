module Concern
  module Marvelable
    def do_call(args={})
      path = "#{self.name.downcase}s"
      params = { path: path }.merge(args)
      data = JSON.parse(MarvelApiService.new.call(params))['data']
      results = data['results']
      characters = results.map { |c| self.class.new(c) }
    end
  end
end

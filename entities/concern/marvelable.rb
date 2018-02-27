require 'active_support/concern'

module Concern
  module Marvelable
    def self.included(base)
    base.extend ClassMethods
    # base.class_eval do
    #   scope :disabled, -> { where(disabled: true) }
    # end
  end


    module ClassMethods
      def do_call(args={})
        plural = self.plural if self.respond_to?(:plural)
        if plural
          path = "#{plural}"
        else
          path = "#{self.name.downcase}s"
        end
        id = args.delete(:id)
        path += "/#{id}" if id
        params = { path: path }.merge(args)
        data = JSON.parse(MarvelApiService.new.call(params))['data']
        results = data['results']
        characters = results.map { |c| self.new(c) }
      end
    end

  end
end

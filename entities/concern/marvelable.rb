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
        klass = args[:nested] ? args[:nested] : self
        path = format_URI(args)
        params = { path: path }.merge(args)
        # puts "URL: #{path}"
        # puts "Params: #{params}"
        data = JSON.parse(MarvelApiService.new.call(params))['data']
        results = data['results']
        characters = results.map { |c| klass.new(c) }
      end

      def format_URI(args)
        pluralize(self) + extract_id(args) + pluralize(args.delete(:nested))
      end

      def pluralize(klass)
        return "" unless klass
        plural = klass.respond_to?(:plural) ? klass.plural : "#{klass.name.downcase}s"
      end

      def extract_id(args)
        id = args.delete(:id)
        return "" unless id
        "/#{id}/"
      end
    end

  end
end

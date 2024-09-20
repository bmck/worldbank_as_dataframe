require 'worldbank_as_dataframe/queriable'
module WorldbankAsDataframe

  class Indicator
    extend WorldbankAsDataframe::Queriable
    attr_reader :raw, :id, :name, :source, :note, :organization, :topics, :type

    def self.country
      find('all').country(arg)
    end

    def self.fetch(arg)
      find(arg).fetch
    end

    def self.featured
      find('all').featured_indicators
    end

    def self.all
      find('all')
    end

    def self.find(id)
      WorldbankAsDataframe::ParamQuery.new('indicators', id, self)
    end

    def initialize(values={})
      @raw = values
      @id = values['id']
      @name = values['name']
      @source = WorldbankAsDataframe::Source.new(values['source'])
      @note = values['sourceNote']
      @organization = values['sourceOrganization']
      @topics = []
      values['topics'].each do |topic| 
        @topics << WorldbankAsDataframe::Topic.new(topic)
      end
      @type = 'indicators'
    end
  end
end

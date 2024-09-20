require 'worldbank_as_dataframe/queriable'
module WorldbankAsDataframe

  class Data
    extend WorldbankAsDataframe::Queriable
    attr_reader :raw, :name, :id, :value, :date, :others

    def self.raw
      find('all').raw
    end

    def self.country(arg)
      find('all').country(arg)
    end

    def self.fetch(arg)
      find(arg).fetch
    end

    def self.all
      find('all')
    end

    def self.find(id)
      WorldbankAsDataframe::DataQuery.new('indicators', id, self)
    end

    def initialize(values={})
      @raw = values
      @name = values['indicator'].delete('value')
      @id = values['indicator'].delete('id')
      @value = values.delete('value')
      @date = values.delete('date')
      values.delete('indicator')
      @others = values
    end
  end
end

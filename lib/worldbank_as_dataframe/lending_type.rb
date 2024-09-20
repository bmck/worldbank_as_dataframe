module WorldbankAsDataframe

  class LendingType

    attr_reader :raw, :id, :name, :type

    def self.all
      find('all')
    end

    def self.find(id)
      WorldbankAsDataframe::ParamQuery.new('lendingTypes', id, self)
    end

    def initialize(values={})
      @raw = values
      @id = values['id']
      @name = values['value']
      @type = 'lendingTypes'
    end
  end
end


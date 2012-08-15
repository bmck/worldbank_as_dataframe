module WorldBank
  module Queriable
    def self.id(arg)
      find('all').id(arg)
    end

    def self.most_recent_values(arg)
      find('all').most_recent_values(arg)
    end

    def self.page(arg)
      find('all').page(arg)
    end

    def self.per_page
      find('all').per_page(arg)
    end

    def self.language(arg)
      find('all').language(arg)
    end

    def self.format(arg)
      find('all').format(arg)
    end

    def self.income_level(arg)
      find('all').income_level(arg)
    end

    def self.lending_type(arg)
      find('all').lending_type(arg)
    end

    def self.region(arg)
      find('all').region(arg)
    end 
  end
  
end
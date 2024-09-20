module WorldbankAsDataframe
  module Queriable    
    def id(arg)
      find('all').id(arg)
    end

    def most_recent_values(arg)
      find('all').most_recent_values(arg)
    end

    def page(arg)
      find('all').page(arg)
    end

    def self.per_page(arg)
      find('all').per_page(arg)
    end

    def language(arg)
      find('all').language(arg)
    end

    def format(arg)
      find('all').format(arg)
    end

    def income_level(arg)
      find('all').income_level(arg)
    end

    def lending_type(arg)
      find('all').lending_type(arg)
    end

    def region(arg)
      find('all').region(arg)
    end
  end  
end
require File.expand_path(File.join(File.dirname(__FILE__), '/worldbank_as_dataframe/client'))

module WorldbankAsDataframe

  def self.client(query={}, raw=false)
      defaults = {:params => {:format => :json}, :dirs => []}
      defaults.merge!(query)
      WorldbankAsDataframe::Client.new(defaults, raw)
    end

    # Delegate to WorldbankAsDataframe::Client.new
    def self.method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def self.respond_to?(method, include_private=false)
      client.respond_to?(method, include_private) || super(method, include_private)
    end

end


module WorldbankAsDataframe
  class Client
    include HTTParty
    # base_uri 'https://api.worldbank.org/v2/'


    attr_accessor :query

    def initialize(query, raw)
      @query = query
      @raw = raw
    end

    def get_query
      @path = 'https://api.worldbank.org/v2/' + @query[:dirs].map(&:downcase).join('/')
      @path += '?'
      params = []
      @query[:params].each do |key, value|
        params << "#{key.to_s}=#{value.to_s}"
      end
      @path += params.join('&')
      get(@path)
    end

    def get(path, headers={})
      begin
        # puts "#{__FILE__}:#{__LINE__} path = #{path.inspect}"
        response = self.class.get(path, headers)
        # puts "#{__FILE__}:#{__LINE__} response = #{response.inspect}"

        response.parsed_response
      rescue
        nil
      end
    end

  private

    # def connection
    #   Faraday.new(:url => 'http://api.worldbank.org/v2') do |connection|
    #     connection.use Faraday::Request::UrlEncoded
    #     connection.use Faraday::Response::RaiseError
    #     connection.use Faraday::Response::Mashify
    #     unless @raw
    #       case @query[:params][:format].to_s.downcase
    #         when 'json'
    #           connection.use Faraday::Response::ParseJson
    #         when 'xml'
    #           connection.use Faraday::Response::ParseXml
    #         end
    #     end
    #     connection.adapter(Faraday.default_adapter)
    #   end
    # end
  end
end

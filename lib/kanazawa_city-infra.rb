require "kanazawa_city-infra/version"
require "faraday"

module KanazawaCity
  module Infra
    URL_ROOT = "https://infra-api.city.kanazawa.ishikawa.jp"

    class << self
      def connection
        Faraday::Connection.new(URL_ROOT, ssl: {verify: false}) do |builder|
          builder.request :url_encoded
          builder.adapter :net_http
        end
      end

      def genres
        res = connection.get '/v1/genres/list.json'
        puts res.body
      end

      def facilities
        #lang ja
        #geocode lat lon radius
        #genre integer or genre_object
        #keyword 
        #count max fetch size
      end

      def facility
        #id
        #lang ja en zh-Hans xzh-Hant ko fr pt es
      end
    end
  end
end

if __FILE__ == $0
  KanazawaCity::Infra.genres
end

# coding: utf-8
require "kanazawa_city/infra/version"
require "httparty"
require "hashie"
require "json"

module KanazawaCity
  module Infra
    include HTTParty
    format :json
    base_uri "https://infra-api.city.kanazawa.ishikawa.jp"
    API_VERSION = 'v1'

    class << self
      def genres(options={})
        options[:lang] ||= "ja"

        res = JSON.parse(get("/#{API_VERSION}/genres/list.json", :query => options).body)

        res["genres"].map do |g|
          that = self
          g[:query_id] = g["id"]
          g = Hashie::Mash.new(g)
          g.subgenres.map! do |sg|
            sg["query_id"] = "#{g["id"]}-#{sg["id"]}"
            sg
          end
          g.freeze
        end
      end

      def facilities(options={})
        options[:lang] ||= "ja"
        options[:genre] &&= 
          if options[:genre].kind_of? Array
            options[:genre].map { |g|
              if g.respond_to? "query_id"
                g.query_id
              elsif g.kind_of?(String) || g.kind_of?(Integer)
                g
              else
               raise ArgumentError 
              end
            }.join(',')
          elsif options[:genre].respond_to? "query_id"
            options[:genre].query_id
          elsif options[:genre].kind_of?(String) || g.kind_of?(Integer)
            options[:genre]
          else 
            raise ArgumentError
          end

        res = JSON.parse(get("/#{API_VERSION}/facilities/search.json", :query => options).body)
        keyword = options[:keyword] || ""
        next_page = res["next_page"] || "" 
        that = self
        res = res["facilities"].map! do |f|
          f["genres"].map! do |g|
            g["query_id"] = g["id"]
            g["subgenre"]["query_id"] = "#{g["id"]}-#{g["subgenre"]["id"]}" if g["subgenre"]
            g
          end
          f = Hashie::Mash.new(f)
          f.singleton_class.send(:define_method, :detail) do
            that.facility(id: f["id"], lang: options[:lang])
          end
          f.freeze
        end
        res.singleton_class.send(:define_method, :"has_next?") do
          ! next_page.empty?
        end

        res.singleton_class.send(:define_method, :next) do
          params = URI.parse(next_page).query.split('&')
          query = params.inject({}) do |query, param|
            k, v = param.split('=')
            if k == "keyword"
              query[k.to_sym] = URI.decode(keyword)
            else
              query[k.to_sym] = URI.decode(v)
            end
            query
          end
          that.facilities(query)
        end

        res
      end

      def facility(options={})
        options[:lang] ||= "ja"

        res = JSON.parse(get("/#{API_VERSION}/facilities/#{options[:id]}.json",
                             :query => {:lang => options[:lang]}).body)

        f = res["facility"]
        f["genres"].map! do |g|
          g["query_id"] = g["id"]
          g["subgenre"]["query_id"] = "#{g["id"]}-#{g["subgenre"]["id"]}" if g["subgenre"]
          g
        end
        f = Hashie::Mash.new(f)
        f.freeze
      end
    end
  end
end


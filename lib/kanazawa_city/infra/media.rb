# coding: utf-8

module KanazawaCity
  module Infra
    class Media 
      attr_reader :source

      def initialize(options)
        @source = options[:source]
      end
    end
  end
end

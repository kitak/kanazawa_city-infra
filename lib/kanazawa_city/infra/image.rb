# coding: utf-8

module KanazawaCity
  module Infra
    class Image < Media 
      attr_reader :thumbnail

      def initialize(options)
        super(options)
        @thumbnail = options[:thumbnail]
      end
    end
  end
end

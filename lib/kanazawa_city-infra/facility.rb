# coding: utf-8

module KanazawaCity
  module Infra
    class Facility
      attr_reader :id
      attr_reader :genres
      attr_reader :name
      attr_reader :summary
      attr_reader :zipcode
      attr_reader :address
      attr_reader :coordinates
      alias_method :coordinate, :coordinates
      attr_reader :tel
      attr_reader :fax
      attr_reader :email
      attr_reader :opening_hours
      attr_reader :closed_days
      attr_reader :fee
      attr_reader :note
      attr_reader :url
      attr_reader :medias

      def initialize
      end

    end
  end
end

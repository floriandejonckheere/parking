# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    RESOURCE_NAME = "car"

    def initialize
      super(loader.load(Parking.root.join("res/#{RESOURCE_NAME}.obj"), "#{RESOURCE_NAME}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      traverse do |child|
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    delegate :is_a?, to: :__getobj__

    private

    def loader
      @loader ||= Mittsu::OBJMTLLoader.new
    end
  end
end

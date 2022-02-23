# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    RESOURCE_NAME = "car"

    def initialize(color = [0.8, 0.8, 0.8])
      super(loader.load(Parking.root.join("res/#{RESOURCE_NAME}.obj"), "#{RESOURCE_NAME}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
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

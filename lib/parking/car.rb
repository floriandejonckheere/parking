# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    def initialize(color = [0.8, 0.8, 0.8])
      super(loader.load(Parking.root.join("res/#{name}.obj"), "#{name}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      position.y = 0.75 if Parking.options.fiat?

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def forward
      position.x += 0.05
    end

    def backward
      position.x -= 0.05
    end

    def left
      rotation.y += 0.03
    end

    def right
      rotation.y -= 0.03
    end

    delegate :is_a?, to: :__getobj__

    private

    def name
      Parking.options.fiat? ? :fiat : :car
    end

    def loader
      @loader ||= Mittsu::OBJMTLLoader.new
    end
  end
end

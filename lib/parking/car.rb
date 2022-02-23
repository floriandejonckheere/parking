# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    # Speed modifier X-axis (forward and backward)
    SPEED_X = 0.1

    # Speed modifier Z-axis (left and right)
    SPEED_Z = 0.1

    attr_reader :initial_rotation

    def initialize(color: [0.8, 0.8, 0.8], r: 1.0)
      super(loader.load(Parking.root.join("res/#{name}.obj"), "#{name}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      position.y = 0.75 if Parking.options.fiat?

      # Rotate to correct orientation
      @initial_rotation = rotation.y = r * (Math::PI / 2)

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def forward
      position.x += Math.cos(rotation.y - initial_rotation) * SPEED_X
      position.z -= Math.sin(rotation.y - initial_rotation) * SPEED_Z
    end

    def backward
      position.x -= Math.cos(rotation.y - initial_rotation) * SPEED_X
      position.z += Math.sin(rotation.y - initial_rotation) * SPEED_Z
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

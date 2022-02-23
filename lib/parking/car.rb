# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    # Speed modifier X-axis (forward and backward)
    SPEED_X = 0.1

    # Speed modifier Z-axis (left and right)
    SPEED_Z = 0.1

    # Steering modifier
    STEERING = 0.03

    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    attr_reader :direction, :steering

    def initialize(color: [0.8, 0.8, 0.8], direction: RIGHT)
      super(loader.load(Parking.root.join("res/#{name}.obj"), "#{name}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      position.y = 0.75 if Parking.options.fiat?

      # Rotate to correct orientation
      @direction = rotation.y = direction * (Math::PI / 2)

      # Set steering wheel
      @steering = 0.0

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def forward
      position.x += Math.cos(rotation.y - direction) * SPEED_X
      position.z -= Math.sin(rotation.y - direction) * SPEED_Z

      rotation.y += steering
    end

    def backward
      position.x -= Math.cos(rotation.y - direction) * SPEED_X
      position.z += Math.sin(rotation.y - direction) * SPEED_Z

      rotation.y += steering
    end

    def left
      @steering = STEERING
    end

    def right
      @steering = -STEERING
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

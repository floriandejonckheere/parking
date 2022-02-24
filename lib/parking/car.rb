# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    attr_reader :direction, :engine, :steering_wheel

    def initialize(color: [0.8, 0.8, 0.8], direction: RIGHT)
      super(loader.load(Parking.root.join("res/#{name}.obj"), "#{name}.mtl"))

      self.receive_shadow = true
      self.cast_shadow = true

      position.y = 0.75 if Parking.options.fiat?

      # Set steering wheel
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new

      # Rotate to correct orientation
      @direction = rotation.y = direction * (Math::PI / 2)

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def drive
      dx, dz = engine.drive(rotation.y - direction)

      position.x += dx
      position.z -= dz

      rotation.y += steering_wheel.direction
    end

    def reverse
      dx, dz = engine.drive(rotation.y - direction)

      position.x -= dx
      position.z += dz

      rotation.y += steering_wheel.direction
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

# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    include CarLoader

    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    attr_reader :meta, :engine, :steering_wheel

    def initialize(model, meta)
      super(model)

      @meta = meta

      self.receive_shadow = true
      self.cast_shadow = true

      # Set to correct height
      position.y = meta.offset

      # Rotate to correct orientation
      rotation.y = (meta.direction * (Math::PI / 2))

      # Initialize car parts
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new(rotation.y)

      traverse do |child|
        child.material.color = meta.color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def drive
      dx, dz = engine.drive(rotation.y)

      position.x += dx
      position.z -= dz

      rotation.y += steering_wheel.direction
    end

    def reverse
      dx, dz = engine.drive(rotation.y)

      position.x -= dx
      position.z += dz

      rotation.y -= steering_wheel.direction
    end

    delegate :is_a?, to: :__getobj__
  end
end

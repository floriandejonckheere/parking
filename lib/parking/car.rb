# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    include CarLoader

    # Acceleration/deceleration modifier
    ACCELERATION = 0.1

    # Coasting modifier
    COAST = 0.04

    MIN_SPEED = -2.0
    MAX_SPEED = 4.0

    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    # Scoring distance of parking position
    DISTANCE = 10.0

    attr_reader :meta, :speed, :engine, :steering_wheel

    def initialize(model, meta)
      super(model)

      @meta = meta
      @speed = 0.0

      self.receive_shadow = true
      self.cast_shadow = true

      # Set to correct height
      position.y = meta.offset
      bounding_box.position.y = position.y

      # Rotate to correct orientation
      rotation.y = (meta.direction * (Math::PI / 2))
      bounding_box.rotation.y = rotation.y

      # Initialize car parts
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new(rotation.y)

      traverse do |child|
        child.material.color = meta.color if child.name == meta.body
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def drive(accelerate: false, decelerate: false)
      dx, dz = engine.drive(rotation.y)

      if accelerate
        # Driver pressed accelerator
        @speed = [speed + ACCELERATION, MAX_SPEED].min
      elsif decelerate
        # Driver pressed brake
        @speed = [speed - ACCELERATION, MIN_SPEED].max
      else
        # Car is coasting
        @speed = speed.negative? ? [speed + COAST, 0.0].min : [speed - COAST, 0.0].max
      end

      # Extract sign from speed modifier
      sign = (speed <=> 0)

      move(position.x + (dx * speed), position.z - (dz * speed), rotation.y + (steering_wheel.direction * sign))
    end

    def move(x, z, ry = rotation.y)
      position.set(x, position.y, z)
      rotation.y = ry

      bounding_box.position.set(x, position.y, z)
      bounding_box.rotation.y = ry
    end

    def collides?(car)
      bounding_box.collides?(car.bounding_box)
    end

    def score
      (DISTANCE - Math.sqrt((position.x**2) + (position.z**2))).abs
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new
    end

    delegate :is_a?, to: :__getobj__
  end
end

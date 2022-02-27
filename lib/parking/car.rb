# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    include CarLoader

    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    # Scoring distance of parking position
    DISTANCE = 10.0

    # Damage modifier
    DAMAGE = 0.1

    attr_reader :meta, :engine, :steering_wheel, :damage

    def initialize(model, meta)
      super(model)

      @meta = meta

      # Set to correct height
      position.y = meta.offset
      bounding_box.position.y = position.y

      # Rotate to correct orientation
      rotation.y = (meta.direction * (Math::PI / 2))
      bounding_box.rotation.y = rotation.y

      # Initialize car parts
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new(rotation.y)

      @damage = 0.0
    end

    def drive(accelerate: false, decelerate: false, brake: false)
      dx, dz = engine.drive(rotation.y, accelerate:, decelerate:, brake:)

      dy = steering_wheel.turn(engine.speed)

      move(position.x + dx, position.z - dz, rotation.y + dy)
    end

    def move(x, z, ry = rotation.y)
      position.set(x, position.y, z)
      rotation.y = ry

      bounding_box.position.set(x, position.y, z)
      bounding_box.rotation.y = ry
    end

    def collide
      @damage += DAMAGE
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

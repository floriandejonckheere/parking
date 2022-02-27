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

    attr_reader :model, :meta, :damage

    def initialize(model, meta)
      @model = model
      @meta = meta

      @damage = 0.0

      group.add(model)
      group.add(bounding_box)

      super(group)

      # Set to correct height
      position.y = meta.offset

      # Rotate to correct orientation
      rotation.y = (meta.direction * (Math::PI / 2))
    end

    def drive(accelerate: false, decelerate: false, brake: false)
      dx, dz = engine.drive(rotation.y, accelerate:, decelerate:, brake:)

      dy = steering_wheel.turn(engine.speed)

      move(position.x + dx, position.z - dz, rotation.y + dy)
    end

    def move(x, z, ry = rotation.y)
      position.set(x, position.y, z)
      rotation.y = ry
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

    delegate :is_a?, to: :__getobj__

    def group
      @group ||= Mittsu::Group.new
    end

    def bounding_box
      @bounding_box ||= BoundingBox.new(meta.bounding_box.width, meta.bounding_box.length, meta.bounding_box.height)
    end

    def steering_wheel
      @steering_wheel ||= SteeringWheel.new
    end

    def engine
      @engine ||= Engine.new(rotation.y)
    end
  end
end

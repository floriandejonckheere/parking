# frozen_string_literal: true

module Parking
  class Engine
    # Speed modifier
    SPEED = 0.1

    MIN_SPEED = -2.0
    MAX_SPEED = 4.0

    # Acceleration/deceleration modifier
    ACCELERATION = 0.1

    # Coasting modifier
    COAST = 0.04

    # Brake modifier
    BRAKE = 0.15

    attr_reader :speed

    # Rotation modifier (car facing left or right)
    attr_reader :ry

    def initialize(ry)
      @speed = 0.0
      @ry = ry
    end

    def drive(rotation, accelerate: false, decelerate: false, brake: false)
      if brake
        # Driver pressed brake
        @speed = speed.negative? ? [speed + BRAKE, 0.0].min : [speed - BRAKE, 0.0].max
      elsif accelerate
        # Driver pressed accelerator
        @speed = [speed + ACCELERATION, MAX_SPEED].min
      elsif decelerate
        # Driver pressed decelerator (reverse)
        @speed = [speed - ACCELERATION, MIN_SPEED].max
      else
        # Car is coasting
        @speed = speed.negative? ? [speed + COAST, 0.0].min : [speed - COAST, 0.0].max
      end

      [
        (Math.cos(rotation - ry) * SPEED) * speed,
        (Math.sin(rotation - ry) * SPEED) * speed,
      ]
    end
  end
end

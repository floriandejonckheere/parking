# frozen_string_literal: true

module Parking
  class Engine
    # Speed modifier
    SPEED = 0.1

    # Rotation modifier (car facing left or right)
    attr_reader :ry

    def initialize(ry)
      @speed = 0.0
      @ry = ry
    end

    def drive(rotation)
      [
        Math.cos(rotation - ry) * SPEED,
        Math.sin(rotation - ry) * SPEED,
      ]
    end
  end
end

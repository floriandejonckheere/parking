# frozen_string_literal: true

module Parking
  class Engine
    # Speed modifier
    SPEED = 0.1

    def drive(rotation)
      [
        Math.cos(rotation) * SPEED,
        Math.sin(rotation) * SPEED,
      ]
    end

    def reverse(rotation)
      [
        Math.cos(rotation) * SPEED,
        Math.sin(rotation) * SPEED,
      ]
    end
  end
end

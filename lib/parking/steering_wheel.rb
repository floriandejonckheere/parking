# frozen_string_literal: true

module Parking
  class SteeringWheel
    # Steering modifier
    STEERING = 0.03

    attr_reader :direction

    def initialize
      @direction = 0.0
    end

    def straight
      @direction = 0.0
    end

    def right
      @direction = -STEERING
    end

    def left
      @direction = STEERING
    end
  end
end

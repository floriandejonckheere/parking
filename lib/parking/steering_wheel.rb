# frozen_string_literal: true

module Parking
  class SteeringWheel
    MIN_STEERING = -0.03
    MAX_STEERING = 0.03

    # Steering modifier
    STEERING = 0.001

    # Coasting modifier
    COAST = 0.002

    # Minimum damping factor
    MIN_DAMPING = 0.2

    attr_reader :steering

    def initialize
      @steering = 0.0
    end

    def steer(left: false, right: false)
      if left
        # Driver steered left
        @steering = [steering + STEERING, MAX_STEERING].min
      elsif right
        # Driver steered right
        @steering = [steering - STEERING, MIN_STEERING].max
      else
        # Driver didn't steer
        @steering = steering.negative? ? [steering + COAST, 0.0].min : [steering - COAST, 0.0].max
      end
    end

    def turn(speed)
      # Dampen steering, so steering is more intense at lower speeds
      # Damping factor is 1.0 when (relative) speed forwards or
      # in reverse is 100%, and MIN_DAMPING when speed is 0%
      damping_factor = [1 - (speed.negative? ? (speed / Engine::MIN_SPEED) : (speed / Engine::MAX_SPEED)), MIN_DAMPING].max

      steering * speed * damping_factor
    end
  end
end

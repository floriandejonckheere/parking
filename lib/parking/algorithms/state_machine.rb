# frozen_string_literal: true

require "aasm"

module Parking
  module Algorithms
    class StateMachine < Algorithm
      include AASM

      # Float comparison threshold
      THRESHOLD = 0.05

      aasm whiny_transitions: false do
        state :idle, initial: true

        # Driving into proper backing up position
        state :driving

        # Braking
        state :braking

        # Reverse turn into parking spot
        state :reversing

        # Reverse until correct
        state :parking

        # Parked
        state :parked

        event :drive do
          transitions from: :idle, to: :driving
          transitions from: :driving, to: :braking, guard: :position_reached?
          transitions from: :braking, to: :reversing, guard: :stopped?
          transitions from: :reversing, to: :parking, guard: :straight?
          transitions from: :parking, to: :parked, guard: :target_reached?
        end
      end

      def driving
        car.drive(accelerate: true)
      end

      def braking
        car.drive(brake: true)
      end

      def reversing
        car.drive(reverse: true, right: true)
      end

      def parking
        car.drive(reverse: true)
      end

      def parked
        car.drive(brake: true)
      end

      def position_reached?
        car.position.x >= target.position.x + 2.5
      end

      def straight?
        (car.rotation.y - Math::PI).abs <= THRESHOLD
      end

      def target_reached?
        car.position.z >= target.position.z
      end

      def stopped?
        car.engine.speed.abs <= THRESHOLD
      end

      def run
        raise "Incompatible layout: algorithm `state_machine` can only be used with layout `reverse`" unless Parking.options.layout == "reverse"

        # Advance state machine
        drive

        # Call corresponding action
        Parking.logger.info aasm.current_state if Parking.options.debug?
        send(aasm.current_state)
      end

      def self.description
        "Algorithm based on a finite state machine"
      end
    end
  end
end

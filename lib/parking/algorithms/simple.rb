# frozen_string_literal: true

module Parking
  module Algorithms
    class Simple < Algorithm
      ACTIONS = [
        *35.times.map { { accelerate: true } },
        *15.times.map { { brake: true } },
        *38.times.map { { reverse: true, right: true } },
        *13.times.map { { reverse: true } },
        *30.times.map { { reverse: true, left: true } },
        *5.times.map { { left: true } },
        *4.times.map { { accelerate: true, right: true } },
        *30.times.map { { accelerate: true } },
        *10.times.map { { brake: true } },
      ].freeze

      def run(car)
        action = iterator.next

        puts action.keys.join(", ")

        car.drive(**action)
      rescue StopIteration
        puts "idle"

        car.drive
      end

      def self.description
        "Simple, step-based algorithm"
      end

      private

      def iterator
        @iterator ||= ACTIONS.each
      end
    end
  end
end

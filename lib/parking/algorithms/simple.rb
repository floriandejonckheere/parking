# frozen_string_literal: true

module Parking
  module Algorithms
    class Simple < Algorithm
      ACTIONS = {
        parallel: [
          *35.times.map { { accelerate: true } },
          *15.times.map { { brake: true } },
          *38.times.map { { reverse: true, right: true } },
          *13.times.map { { reverse: true } },
          *30.times.map { { reverse: true, left: true } },
          *5.times.map { { left: true } },
          *4.times.map { { accelerate: true, right: true } },
          *30.times.map { { accelerate: true } },
          *10.times.map { { brake: true } },
        ],
        reverse: [
          *32.times.map { { accelerate: true } },
          *30.times.map { { brake: true } },
          *2.times.map { { reverse: true } },
          *61.times.map { { reverse: true, right: true } },
          *11.times.map { { reverse: true } },
          *15.times.map { { brake: true } },
        ],
      }.freeze

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
        @iterator ||= ACTIONS[Parking.options.layout.to_sym].each
      end
    end
  end
end

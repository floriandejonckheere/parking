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

      def run
        action = iterator.next

        log(action)

        car.drive(**action)
      rescue StopIteration
        log(idle: true)

        car.drive
      end

      def self.description
        "Simple, step-based algorithm"
      end

      private

      def iterator
        @iterator ||= ACTIONS[Parking.options.layout.to_sym].each
      end

      def log(action)
        return unless Parking.options.debug?

        # Don't log actions twice
        return if @action == action

        Parking.logger.info action.keys.join(", ")

        @action = action
      end
    end
  end
end

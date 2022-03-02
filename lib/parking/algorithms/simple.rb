# frozen_string_literal: true

module Parking
  module Algorithms
    class Simple < Algorithm
      ACTIONS = {
        parallel: [
          [35, { accelerate: true }],
          [15, { brake: true }],
          [38, { reverse: true, right: true }],
          [13, { reverse: true }],
          [30, { reverse: true, left: true }],
          [5, { left: true }],
          [4, { accelerate: true, right: true }],
          [30, { accelerate: true }],
          [10, { brake: true }],
        ],
        reverse: [
          [32, { accelerate: true }],
          [30, { brake: true }],
          [2, { reverse: true }],
          [61, { reverse: true, right: true }],
          [11, { reverse: true }],
          [15, { brake: true }],
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
        @iterator ||= Iterator.new(ACTIONS[Parking.options.layout.to_sym])
      end

      def log(action)
        # Don't log actions twice
        return if @action == action

        Parking.logger.debug action.keys.join(", ")

        @action = action
      end
    end
  end
end

# frozen_string_literal: true

module Parking
  module Algorithms
    class Random < Simple
      def run
        action = iterator.next

        log(action)

        car.drive(**action)
      rescue StopIteration
        puts "Final score for #{numbers} = #{car.score(target)}"

        # Reset simulation
        @iterator = nil

        reset.call
      end

      def self.description
        "Random algorithm"
      end

      private

      def numbers
        [35, 15, 38, 13, 30, 5, 4, 30, 10]
      end

      def iterator
        @iterator ||= Iterator.new(numbers.zip(ACTIONS[Parking.options.layout.to_sym].map(&:last)))
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

# frozen_string_literal: true

module Parking
  module Algorithms
    class Random < Simple
      # Maximum number of attempts
      MAX_ATTEMPTS = 5

      attr_reader :attempt, :results

      def initialize(...)
        super

        @attempt = 0
        @results = {}
      end

      def run
        action = iterator.next

        car.drive(**action)
      rescue StopIteration
        results[numbers] = car.score(target)

        Parking.logger.debug "Score for attempt #{attempt} #{numbers} = #{car.score(target)}"

        if (@attempt += 1) == MAX_ATTEMPTS
          result, score = results.max_by(&:last)
          Parking.logger.info "Best score: #{score.truncate(2)} with input #{result}"

          exit
        end

        # Reset simulation
        @iterator = nil

        # Mutate numbers
        @numbers = mutate(numbers)

        reset.call
      end

      def self.description
        "Randomized selection algorithm"
      end

      private

      def numbers
        @numbers ||= mutate(actions.map(&:first))
      end

      def mutate(numbers)
        # Mutate numbers with 25% chance
        numbers.map { |n| Parking.random.rand(0..2).zero? ? n + Parking.random.rand(-10..10) : n }
      end

      def iterator
        @iterator ||= Iterator.new(numbers.zip(actions.map(&:last)))
      end
    end
  end
end

# frozen_string_literal: true

module Parking
  module Algorithms
    class Simple
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

      attr_reader :cursor

      def initialize
        @cursor = 0
      end

      def run(car)
        puts action.keys.join(", ")

        car.drive(**action)

        @cursor += 1
      end

      private

      def action
        ACTIONS[cursor] || {}
      end
    end
  end
end

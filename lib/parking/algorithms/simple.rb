# frozen_string_literal: true

module Parking
  module Algorithms
    class Simple
      def run(car)
        puts "Position (#{car.score.truncate(2)}) - damage (#{car.damage.truncate(2)}) = score (#{(car.score - car.damage).truncate(2)})"
      end
    end
  end
end

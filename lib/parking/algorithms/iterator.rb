# frozen_string_literal: true

module Parking
  module Algorithms
    class Iterator < SimpleDelegator
      def initialize(data)
        Parking.logger.debug "Iterating #{data.map(&:first)}"

        super(data.flat_map { |n, v| n.times.map { v } }.each)
      end
    end
  end
end

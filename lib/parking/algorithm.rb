# frozen_string_literal: true

module Parking
  class Algorithm
    attr_reader :car, :target

    def initialize(car, target)
      @car = car
      @target = target
    end

    ##
    # Called on every tick (~ screen refresh rate)
    # Use `car` and `target` to process sensory data
    # and control the car (using Car#drive)
    #
    def run
      raise NotImplementedError
    end

    ##
    # Short description of the algorithm
    #
    def self.description
      raise NotImplementedError
    end
  end
end

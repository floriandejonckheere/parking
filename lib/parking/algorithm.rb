# frozen_string_literal: true

module Parking
  class Algorithm
    attr_accessor :car
    attr_reader :target, :reset

    def initialize(car, target, reset)
      @car = car
      @target = target
      @reset = reset
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

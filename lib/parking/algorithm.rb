# frozen_string_literal: true

module Parking
  class Algorithm
    ##
    # Called on every tick (~ screen refresh rate)
    # Use the `car` argument to process sensory data
    # and control the car (using Car#drive)
    #
    def run(_car)
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

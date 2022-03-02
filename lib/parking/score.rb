# frozen_string_literal: true

module Parking
  ##
  # Score calculator
  #
  class Score
    # Maximum distance from target, beyond which score will be 0.0
    DISTANCE = 10.0

    attr_reader :subject, :target

    def initialize(subject, target)
      @subject = subject
      @target = target
    end

    def score
      (DISTANCE - Math.sqrt(((target.position.x - subject.position.x)**2) + ((target.position.z - subject.position.z)**2))).abs
    end
  end
end

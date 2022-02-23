# frozen_string_literal: true

module Parking
  class Camera < SimpleDelegator
    def initialize
      super(Mittsu::PerspectiveCamera.new(75.0, Parking.options.aspect, 0.1, 1000.0))

      sideways
    end

    def sideways
      position.z = 7.5
      position.y = 7.5

      rotation.x = -0.5
    end

    def top_down
      position.z = 0
      position.y = 10.0

      rotation.x = -Math::PI / 2
    end

    delegate :is_a?, to: :__getobj__
  end
end

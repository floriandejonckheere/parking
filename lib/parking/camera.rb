# frozen_string_literal: true

module Parking
  class Camera < SimpleDelegator
    def initialize
      super(Mittsu::PerspectiveCamera.new(75.0, Parking.options.aspect, 0.1, 1000.0))

      sideways
    end

    def sideways
      position.z = 4.5
      position.y = 5

      rotation.x = -0.5
    end

    def top_down
      position.z = -1.5
      position.y = 10.0

      rotation.x = -Math::PI / 2
    end

    delegate :is_a?, to: :__getobj__

    class Container < SimpleDelegator
      attr_reader :camera

      def initialize(camera)
        super(Mittsu::Object3D.new)
        @camera = camera

        add(camera)
      end

      def sideways
        rotation.x = 0
        rotation.y = 0
        rotation.z = 0

        camera.sideways
      end

      def top_down
        rotation.x = 0
        rotation.y = 0
        rotation.z = 0

        camera.top_down
      end

      delegate :is_a?, to: :__getobj__
    end
  end
end

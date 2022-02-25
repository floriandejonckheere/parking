# frozen_string_literal: true

module Parking
  class Camera < SimpleDelegator
    # Speed modifier
    SPEED = 0.1

    def initialize
      super(Mittsu::PerspectiveCamera.new(75.0, Parking.options.aspect, 0.1, 1000.0))

      sideways
    end

    def up = position.z -= SPEED
    def down = position.z += SPEED
    def left = position.x -= SPEED
    def right = position.x += SPEED

    def zoom_in = position.y += SPEED
    def zoom_out = position.y -= SPEED

    def sideways
      position.x = 0.0
      position.z = 4.5
      position.y = 5

      rotation.x = -0.5
    end

    def top_down
      position.x = 0.0
      position.z = 0.0
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

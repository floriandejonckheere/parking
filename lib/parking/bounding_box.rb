# frozen_string_literal: true

module Parking
  class BoundingBox < SimpleDelegator
    WIDTH = 2.4
    LENGTH = 4.5
    HEIGHT = 3.0

    def initialize
      super(mesh)
    end

    delegate :is_a?, to: :__getobj__

    private

    def mesh
      @mesh ||= Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(WIDTH, HEIGHT, LENGTH),
        Mittsu::MeshBasicMaterial.new(color: 0x00ff00, wireframe: true),
      )
    end
  end
end

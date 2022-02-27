# frozen_string_literal: true

module Parking
  class BoundingBox < SimpleDelegator
    attr_reader :width, :length, :height

    def initialize(width, length, height)
      @width = width
      @length = length
      @height = height

      super(mesh)
    end

    # https://discourse.threejs.org/t/collisions-two-objects/4125/2
    def collides?(bounding_box)
      # Compute bounding boxes
      geometry.compute_bounding_box
      bounding_box.geometry.compute_bounding_box

      # Update transformation matrices
      update_matrix_world
      bounding_box.update_matrix_world

      # Apply transformation matrix to bounding boxes
      bb1 = geometry.bounding_box.clone
      bb1.apply_matrix4(matrix_world)

      bb2 = bounding_box.geometry.bounding_box.clone
      bb2.apply_matrix4(bounding_box.matrix_world)

      bb1.intersection_box?(bb2)
    end

    def color=(value)
      mesh.material.color.set_rgb(*value)
    end

    delegate :is_a?, to: :__getobj__

    def mesh
      @mesh ||= Mittsu::Mesh.new(
        geometry,
        Mittsu::MeshBasicMaterial.new(color: 0x00ff00, wireframe: true, transparent: !Parking.options.debug?, opacity: Parking.options.debug? ? 1.0 : 0.0),
      )
    end

    def geometry
      @geometry ||= Mittsu::BoxGeometry.new(width, height, length)
    end
  end
end

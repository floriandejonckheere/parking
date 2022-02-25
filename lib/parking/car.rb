# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    include CarLoader

    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    attr_reader :meta, :engine, :steering_wheel

    def initialize(model, meta)
      super(model)

      @meta = meta

      self.receive_shadow = true
      self.cast_shadow = true

      # Set to correct height
      position.y = meta.offset
      bounding_box.position.y = position.y

      # Rotate to correct orientation
      rotation.y = (meta.direction * (Math::PI / 2))
      bounding_box.rotation.y = rotation.y

      # Initialize car parts
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new(rotation.y)

      traverse do |child|
        child.material.color = meta.color if child.name == meta.body
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def drive
      dx, dz = engine.drive(rotation.y)

      position.x += dx
      position.z -= dz

      bounding_box.position.x = position.x
      bounding_box.position.z = position.z

      rotation.y += steering_wheel.direction

      bounding_box.rotation.y = rotation.y
    end

    def reverse
      dx, dz = engine.drive(rotation.y)

      position.x -= dx
      position.z += dz

      bounding_box.position.x = position.x
      bounding_box.position.z = position.z

      rotation.y -= steering_wheel.direction

      bounding_box.rotation.y = rotation.y
    end

    def bounding_box
      @bounding_box ||= Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(2.4, 3.0, 4.5),
        Mittsu::MeshBasicMaterial.new(color: 0xff0000, wireframe: true),
      )
    end

    delegate :is_a?, to: :__getobj__
  end
end

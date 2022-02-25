# frozen_string_literal: true

module Parking
  class Car < SimpleDelegator
    # Facing left/right
    LEFT = -1.0
    RIGHT = 1.0

    attr_reader :length, :engine, :steering_wheel

    def initialize(color: Colors::GREY, direction: RIGHT)
      super(model)

      self.receive_shadow = true
      self.cast_shadow = true

      # Set to correct height
      position.y = meta[:offset]

      # Rotate to correct orientation
      rotation.y = (direction * (Math::PI / 2))

      # Initialize car parts
      @steering_wheel = SteeringWheel.new
      @engine = Engine.new(rotation.y)

      @length = meta[:length]

      traverse do |child|
        child.material.color = color if child.name == "Car_Cube Body"
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    def drive
      dx, dz = engine.drive(rotation.y)

      position.x += dx
      position.z -= dz

      rotation.y += steering_wheel.direction
    end

    def reverse
      dx, dz = engine.drive(rotation.y)

      position.x -= dx
      position.z += dz

      rotation.y += steering_wheel.direction
    end

    delegate :is_a?, to: :__getobj__

    private

    def model
      loader.load(Parking.root.join("res/#{Parking.options.model}.obj"), "#{Parking.options.model}.mtl")
    end

    def meta
      YAML
        .load_file(Parking.root.join("res/#{Parking.options.model}.yml").to_s)
        .symbolize_keys
    end

    def loader
      @loader ||= Mittsu::OBJMTLLoader.new
    end
  end
end

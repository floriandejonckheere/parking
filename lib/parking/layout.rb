# frozen_string_literal: true

module Parking
  class Layout
    def car
      @car ||= Car.load(color: Colors::RED).tap do |car|
        car.position.set(
          layout[:car].fetch(:x, 0.0),
          layout[:car].fetch(:y, 0.0),
          layout[:car].fetch(:z, 0.0),
        )
      end
    end

    def parked_cars
      @parked_cars ||= layout[:parked_cars].map do |parked_car|
        Car.load(direction: parked_car.fetch(:d, 1.0)).tap do |car|
          car.position.set(
            parked_car.fetch(:x, 0.0) * car.meta.length,
            parked_car.fetch(:y, 0.0),
            parked_car.fetch(:z, 0.0) * car.meta.width,
          )
        end
      end
    end

    def target
      Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(car.bounding_box.width, 0.01, car.bounding_box.length),
        Mittsu::MeshBasicMaterial.new(color: 0x006cb3),
      ).tap do |target|
        target.receive_shadow = true

        # Set initial position
        target.position.set(
          layout[:target].fetch(:x, 0.0),
          layout[:target].fetch(:y, 0.0),
          layout[:target].fetch(:z, 0.0),
        )
        target.rotation.y = layout[:target].fetch(:d, 0.0) * (Math::PI / 2)
      end
    end

    def reset
      @car = nil
    end

    private

    def layout
      @layout ||= YAML
        .load_file(Parking.root.join("res/layouts/#{Parking.options.layout}.yml").to_s)
        .deep_symbolize_keys
    end
  end
end

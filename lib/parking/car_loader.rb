# frozen_string_literal: true

module Parking
  module CarLoader
    extend ActiveSupport::Concern

    class_methods do
      def load(color: Colors::GREY, direction: Car::RIGHT)
        model = loader.load(Parking.root.join("res/#{Parking.options.model}.obj"), "#{Parking.options.model}.mtl")
        meta = OpenStruct.new YAML
          .load_file(Parking.root.join("res/#{Parking.options.model}.yml").to_s)
          .symbolize_keys

        meta.color = color
        meta.direction = direction

        new(model, meta).tap do |car|
          car.receive_shadow = true
          car.cast_shadow = true

          car.traverse do |child|
            child.material.color = meta.color if child.name == meta.body
            child.receive_shadow = true
            child.cast_shadow = true
          end
        end
      end

      private

      def loader
        @loader ||= Mittsu::OBJMTLLoader.new
      end
    end
  end
end

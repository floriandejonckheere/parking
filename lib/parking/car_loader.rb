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

        new(model, meta)
      end

      private

      def loader
        @loader ||= Mittsu::OBJMTLLoader.new
      end
    end
  end
end

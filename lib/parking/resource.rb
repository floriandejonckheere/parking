# frozen_string_literal: true

module Parking
  class Resource
    attr_reader :object

    def initialize(resource_name)
      @object = loader.load(Parking.root.join("res/#{resource_name}.obj"), "#{resource_name}.mtl")

      object.receive_shadow = true
      object.cast_shadow = true

      object.traverse do |child|
        child.receive_shadow = true
        child.cast_shadow = true
      end
    end

    delegate_missing_to :object

    private

    def loader
      @loader ||= Mittsu::OBJMTLLoader.new
    end
  end
end

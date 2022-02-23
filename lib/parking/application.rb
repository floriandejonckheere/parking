# frozen_string_literal: true

module Parking
  class Application
    def start
      # Add cars
      parked_cars.each { |car| scene.add(car.object) }
      scene.add(car.object)

      scene.print_tree

      # Add floor
      scene.add(floor)

      # Add lights
      scene.add(ambient_light)
      scene.add(spot_light)

      render
    end

    private

    def render
      renderer.window.on_resize do |width, height|
        renderer.set_viewport(0, 0, width, height)
        camera.aspect = width.to_f / height
        camera.update_projection_matrix
      end

      renderer.window.run do
        car.position.x += 0.01

        renderer.render(scene, camera)
      end
    end

    def car
      @car ||= Car.new.tap do |car|
        car.rotation.y = Math::PI / 2
      end
    end

    def parked_cars
      cars = []

      # Parked cars
      cars << Car.new.tap do |car|
        car.rotation.y = Math::PI / 2
        car.position.x = -5.0
        car.position.z = -2.5
      end

      cars << Car.new.tap do |car|
        car.rotation.y = Math::PI / 2
        car.position.x = 5.0
        car.position.z = -2.5
      end

      cars
    end

    def floor
      Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(1000.0, 1.0, 1000.0),
        Mittsu::MeshPhongMaterial.new(color: 0xffffff),
      ).tap do |floor|
        floor.position.y = -0.5
        floor.receive_shadow = true
      end
    end

    def ambient_light
      Mittsu::AmbientLight.new(0xffffff)
    end

    def spot_light
      Mittsu::SpotLight.new(0xffffff, 1.0).tap do |light|
        light.position.set(300.0, 200.0, 0.0)

        light.cast_shadow = true
        light.shadow_darkness = 0.5

        light.shadow_map_width = 1024
        light.shadow_map_height = 1024

        light.shadow_camera_near = 1.0
        light.shadow_camera_far = 2000.0
        light.shadow_camera_fov = 60.0

        light.shadow_camera_visible = false
      end
    end

    def renderer
      @renderer ||= Mittsu::OpenGLRenderer.new(
        width: Parking.options.width,
        height: Parking.options.height,
        title: "Parking",
      ).tap do |renderer|
        renderer.shadow_map_enabled = true
        renderer.shadow_map_type = Mittsu::PCFSoftShadowMap
      end
    end

    def scene
      @scene ||= Mittsu::Scene.new
    end

    def camera
      @camera ||= Camera.new
    end
  end
end

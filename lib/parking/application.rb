# frozen_string_literal: true

module Parking
  class Application
    X_AXIS = Mittsu::Vector3.new(1.0, 0.0, 0.0)
    Y_AXIS = Mittsu::Vector3.new(0.0, 1.0, 0.0)

    def start
      # Add cars
      parked_cars.each { |car| scene.add(car) }
      scene.add(car)

      scene.print_tree

      # Add floor
      scene.add(floor)

      # Add lights
      scene.add(ambient_light)
      scene.add(spot_light)

      # Add camera
      scene.add(camera_container)

      render
    end

    private

    def render
      renderer.window.on_resize do |width, height|
        renderer.set_viewport(0, 0, width, height)
        camera.aspect = width.to_f / height
        camera.update_projection_matrix
      end

      renderer.window.on_mouse_button_pressed do |button, position|
        next unless button == GLFW_MOUSE_BUTTON_LEFT

        last_mouse_position.copy(position)
      end

      renderer.window.on_mouse_move do |position|
        next unless renderer.window.mouse_button_down?(GLFW_MOUSE_BUTTON_LEFT)

        mouse_delta.copy(last_mouse_position).sub(position)
        last_mouse_position.copy(position)

        camera_container.rotate_on_axis(Y_AXIS, mouse_delta.x * 0.01)
        camera_container.rotate_on_axis(X_AXIS, mouse_delta.y * 0.01)
      end

      renderer.window.on_key_typed do |key|
        case key
        when GLFW_KEY_UP
          camera_container.top_down
        when GLFW_KEY_DOWN
          camera_container.sideways
        end
      end

      renderer.window.run do
        car.position.x += 0.01

        renderer.render(scene, camera)
      end
    end

    def car
      @car ||= Car.new([1.0, 0.0, 0.0]).tap do |car|
        car.rotation.y = Math::PI / 2
      end
    end

    def parked_cars
      [
        { x: -6.0, z: -3.0 },
        { x: 6.0, z: -3.0 },

        { x: -6.0, z: 3.0 },
        { x: 0.0, z: 3.0 },
        { x: 6.0, z: 3.0 },
      ].map do |coords|
        Car.new.tap do |car|
          car.rotation.y = Math::PI / 2
          car.position.x = coords[:x]
          car.position.z = coords[:z]
        end
      end
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

    def camera_container
      @camera_container ||= Camera::Container.new(camera)
    end

    def mouse_delta
      @mouse_delta ||= Mittsu::Vector2.new
    end

    def last_mouse_position
      @last_mouse_position ||= Mittsu::Vector2.new
    end
  end
end

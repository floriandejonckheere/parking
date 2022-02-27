# frozen_string_literal: true

module Parking
  class Application
    X_AXIS = Mittsu::Vector3.new(1.0, 0.0, 0.0)
    Y_AXIS = Mittsu::Vector3.new(0.0, 1.0, 0.0)

    # Camera mode (:scene or :car)
    attr_reader :camera_mode

    def initialize
      @camera_mode = :scene
    end

    def start
      # Add cars
      parked_cars.each { |car| scene.add(car) }
      scene.add(car)

      scene.print_tree if Parking.options.debug?

      # Add floor
      scene.add(floor)
      scene.add(target)

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

      renderer.window.on_scroll do |offset|
        scroll_factor = (1.5**(offset.y * 0.1))
        camera.zoom *= scroll_factor
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
        when GLFW_KEY_PAGE_UP
          camera_container.top_down
        when GLFW_KEY_PAGE_DOWN
          camera_container.sideways
        when GLFW_KEY_V
          @camera_mode = (camera_mode == :scene ? :car : :scene)
        when GLFW_KEY_Q
          exit
        end
      end

      renderer.window.run do
        renderer.render(scene, current_camera)

        parked_cars.each do |parked_car|
          collision = car.collides?(parked_car)

          if collision
            parked_car.bounding_box.color = Colors::RED
          else
            parked_car.bounding_box.color = Colors::GREEN
          end

          car.collide if collision
        end

        # Move camera
        camera.up if renderer.window.key_down?(GLFW_KEY_UP)
        camera.down if renderer.window.key_down?(GLFW_KEY_DOWN)
        camera.left if renderer.window.key_down?(GLFW_KEY_LEFT)
        camera.right if renderer.window.key_down?(GLFW_KEY_RIGHT)

        camera.zoom_in if renderer.window.key_down?(GLFW_KEY_EQUAL)
        camera.zoom_out if renderer.window.key_down?(GLFW_KEY_MINUS)

        next algorithm.run(car) if Parking.options.automatic?

        # Drive
        car.drive(
          accelerate: renderer.window.key_down?(GLFW_KEY_W),
          reverse: renderer.window.key_down?(GLFW_KEY_S),
          brake: renderer.window.key_down?(GLFW_KEY_SPACE),
          left: renderer.window.key_down?(GLFW_KEY_A),
          right: renderer.window.key_down?(GLFW_KEY_D),
        )
      end
    end

    def algorithm
      @algorithm ||= "Parking::Algorithms::#{Parking.options.algorithm.camelize}".constantize.new
    end

    def layout
      @layout ||= Layout.new
    end

    delegate :car, :parked_cars, to: :layout

    def floor
      Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(1000.0, 1.0, 1000.0),
        Mittsu::MeshPhongMaterial.new(color: 0x848484),
      ).tap do |floor|
        floor.position.y = -0.5
        floor.receive_shadow = true
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
          layout.layout[:target].fetch(:x, 0.0),
          layout.layout[:target].fetch(:y, 0.0),
          layout.layout[:target].fetch(:z, 0.0),
        )
        target.rotation.y = layout.layout[:target].fetch(:d, 0.0) * (Math::PI / 2)
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

    def current_camera
      camera_mode == :scene ? camera : car.camera
    end

    def mouse_delta
      @mouse_delta ||= Mittsu::Vector2.new
    end

    def last_mouse_position
      @last_mouse_position ||= Mittsu::Vector2.new
    end
  end
end

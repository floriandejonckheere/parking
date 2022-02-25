# frozen_string_literal: true

module Parking
  class Application
    X_AXIS = Mittsu::Vector3.new(1.0, 0.0, 0.0)
    Y_AXIS = Mittsu::Vector3.new(0.0, 1.0, 0.0)

    # Damage modifier
    DAMAGE = 0.1

    attr_reader :damage

    def initialize
      @damage = 0.0
    end

    def start
      # Add cars
      parked_cars.each do |car|
        scene.add(car)
        scene.add(car.bounding_box)
      end

      scene.add(car)
      scene.add(car.bounding_box)

      scene.print_tree

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
        when GLFW_KEY_Q
          exit
        end
      end

      renderer.window.run do
        renderer.render(scene, camera)

        collisions = parked_cars.filter_map do |parked_car|
          collision = car.collides?(parked_car)

          if collision
            parked_car.bounding_box.color = Colors::RED
          else
            parked_car.bounding_box.color = Colors::GREEN
          end

          parked_car if collision
        end

        @damage += (collisions.count * DAMAGE)

        # puts "Position (#{car.score.truncate(2)}) - damage (#{damage.truncate(2)}) = score (#{(car.score - damage).truncate(2)})"

        # Move camera
        camera.up if renderer.window.key_down?(GLFW_KEY_UP)
        camera.down if renderer.window.key_down?(GLFW_KEY_DOWN)
        camera.left if renderer.window.key_down?(GLFW_KEY_LEFT)
        camera.right if renderer.window.key_down?(GLFW_KEY_RIGHT)

        camera.zoom_in if renderer.window.key_down?(GLFW_KEY_EQUAL)
        camera.zoom_out if renderer.window.key_down?(GLFW_KEY_MINUS)

        next algorithm.run if Parking.options.automatic?

        # Steer
        if renderer.window.key_down?(GLFW_KEY_D)
          car.steering_wheel.right
        elsif renderer.window.key_down?(GLFW_KEY_A)
          car.steering_wheel.left
        else
          car.steering_wheel.straight
        end

        # Drive/reverse
        car.drive(
          accelerate: renderer.window.key_down?(GLFW_KEY_W),
          decelerate: renderer.window.key_down?(GLFW_KEY_S),
        )
      end
    end

    def car
      @car ||= Car.load(color: Colors::RED).tap do |car|
        car.move(0.0, -3.0)
      end
    end

    def algorithm
      @algorithm ||= Algorithms::Simple.new
    end

    def parked_cars
      @parked_cars ||= [
        { x: -2.0, z: -9.0, d: Car::LEFT },
        { x: -1.0, z: -9.0, d: Car::LEFT },
        { x: 0.0, z: -9.0, d: Car::LEFT },
        { x: 1.0, z: -9.0, d: Car::LEFT },
        { x: 2.0, z: -9.0, d: Car::LEFT },

        { x: -2.0, z: 0.0 },
        { x: -1.0, z: 0.0 },
        { x: 1.0, z: 0.0 },
        { x: 2.0, z: 0.0 },
      ].map do |coords|
        Car.load(direction: coords.fetch(:d, Car::RIGHT)).tap do |car|
          car.move(coords[:x] * car.meta.length, coords[:z])
        end
      end
    end

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
        Mittsu::BoxGeometry.new(BoundingBox::WIDTH, 0.01, BoundingBox::LENGTH),
        Mittsu::MeshBasicMaterial.new(color: 0x006cb3),
      ).tap do |target|
        target.rotation.y = Math::PI / 2
        target.receive_shadow = true
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

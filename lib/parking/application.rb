# frozen_string_literal: true

module Parking
  class Application
    attr_reader :car

    def start
      setup_renderer

      load_resources

      generate_floor

      create_lights

      setup_camera

      render
    end

    private

    def setup_renderer
      renderer.shadow_map_enabled = true
      renderer.shadow_map_type = Mittsu::PCFSoftShadowMap

      renderer.window.on_resize do |width, height|
        renderer.set_viewport(0, 0, width, height)
        camera.aspect = width.to_f / height
        camera.update_projection_matrix
      end
    end

    def load_resources
      @car = loader.load(Parking.root.join("res/car.obj"), "car.mtl")

      car.receive_shadow = true
      car.cast_shadow = true

      car.traverse do |child|
        child.receive_shadow = true
        child.cast_shadow = true
      end

      scene.add(car)
      scene.print_tree
    end

    def generate_floor
      floor = Mittsu::Mesh.new(
        Mittsu::BoxGeometry.new(1000.0, 1.0, 1000.0),
        Mittsu::MeshPhongMaterial.new(color: 0xffffff),
      )
      floor.position.y = -0.5
      floor.receive_shadow = true
      scene.add(floor)
    end

    def create_lights
      scene.add Mittsu::AmbientLight.new(0xffffff)

      light = Mittsu::SpotLight.new(0xffffff, 1.0)
      light.position.set(300.0, 200.0, 0.0)

      light.cast_shadow = true
      light.shadow_darkness = 0.5

      light.shadow_map_width = 1024
      light.shadow_map_height = 1024

      light.shadow_camera_near = 1.0
      light.shadow_camera_far = 2000.0
      light.shadow_camera_fov = 60.0

      light.shadow_camera_visible = false
      scene.add(light)
    end

    def setup_camera
      camera.position.z = 10.0
      camera.position.y = 5.0
    end

    def render
      renderer.window.run do
        car.rotation.y += 0.05

        renderer.render(scene, camera)
      end
    end

    def renderer
      @renderer ||= Mittsu::OpenGLRenderer.new(
        width: Parking.options.width,
        height: Parking.options.height,
        title: "Parking",
      )
    end

    def scene
      @scene ||= Mittsu::Scene.new
    end

    def camera
      @camera ||= Mittsu::PerspectiveCamera.new(75.0, Parking.options.aspect, 0.1, 1000.0)
    end

    def loader
      @loader ||= Mittsu::OBJMTLLoader.new
    end
  end
end

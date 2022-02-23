# frozen_string_literal: true

module Parking
  class Options
    attr_accessor :help

    attr_writer :width, :height

    def width
      @width ||= 800
    end

    def height
      @height ||= 600
    end

    def aspect
      width.to_f / height
    end

    def verbose=(value)
      @verbose = value.present?
    end

    def verbose
      @verbose ||= false
    end

    def verbose?
      verbose.present?
    end

    def debug=(value)
      @debug = value.present?
    end

    def debug
      @debug ||= false
    end

    def debug?
      debug.present?
    end

    def [](key)
      send(key)
    end

    def []=(key, value)
      send(:"#{key}=", value)
    end
  end
end

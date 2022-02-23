# frozen_string_literal: true

module CoreExt
  module String
    # Adapted from active_model/types/boolean
    # rubocop:disable Lint/BooleanSymbol
    FALSE_VALUES = [
      false, 0,
      "0", :"0",
      "f", :f,
      "F", :F,
      "false", :false,
      "FALSE", :FALSE,
      "off", :off,
      "OFF", :OFF,
    ].freeze
    # rubocop:enable Lint/BooleanSymbol

    # Maximum number of characters displayed
    LENGTH = 75

    def to_b
      self == "" ? nil : FALSE_VALUES.exclude?(self)
    end

    def as_h
      self
    end

    def as_s
      "\"#{chomp.tr("\n", ' ').truncate(LENGTH)}\""
    end
  end
end

String.prepend CoreExt::String

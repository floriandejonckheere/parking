# frozen_string_literal: true

module CoreExt
  module Boolean
    def to_b
      self
    end

    def as_h
      self
    end

    def as_s
      to_s
    end
  end
end

TrueClass.prepend CoreExt::Boolean
FalseClass.prepend CoreExt::Boolean

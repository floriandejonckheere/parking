# frozen_string_literal: true

module CoreExt
  module NilClass
    def to_b
      self
    end

    def as_h
      self
    end

    def as_s
      "nil"
    end
  end
end

NilClass.prepend CoreExt::NilClass

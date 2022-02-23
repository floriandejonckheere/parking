# frozen_string_literal: true

module CoreExt
  module Integer
    def as_h
      self
    end

    def as_s
      to_s
    end
  end
end

Integer.prepend CoreExt::Integer

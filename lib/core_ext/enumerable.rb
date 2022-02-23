# frozen_string_literal: true

module CoreExt
  module Enumerable
    def intersperse(value)
      flat_map { |h| [h, value] }.tap(&:pop)
    end

    def as_h
      map(&:as_h)
    end

    def as_s
      return "[]" if empty?

      map { |k| "  #{k.as_s}" }
        .intersperse(",")
        .each_slice(2)
        .map(&:join)
        .prepend("[")
        .append("]")
        .join("\n")
    end
  end
end

Enumerable.prepend CoreExt::Enumerable

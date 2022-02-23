# frozen_string_literal: true

module CoreExt
  module Hash
    def as_h
      transform_values(&:as_h)
    end

    def as_s
      return "{}" if empty?

      map { |k, v| "  #{k} = #{v.as_s}" }
        .intersperse(",")
        .each_slice(2)
        .map(&:join)
        .prepend("{")
        .append("}")
        .join("\n")
    end
  end
end

Hash.prepend CoreExt::Hash

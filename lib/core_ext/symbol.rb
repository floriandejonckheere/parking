# frozen_string_literal: true

module CoreExt
  module Symbol
    delegate :as_h,
             :as_s,
             to: :to_s
  end
end

Symbol.prepend CoreExt::Symbol

# frozen_string_literal: true

module CoreExt
  module Time
    def as_h
      iso8601
    end

    def as_s
      iso8601
    end
  end
end

Time.prepend CoreExt::Time
ActiveSupport::TimeWithZone.prepend CoreExt::Time

# frozen_string_literal: true

module Parking
  # Base class
  class Error < StandardError; end

  # Raised when usage is printed
  class ExitError < Error; end

  # Raised when CLI arguments are invalid
  class UsageError < Error; end
end

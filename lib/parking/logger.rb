# frozen_string_literal: true

require "delegate"
require "logger"

require "colorize"

module Parking
  class Logger < SimpleDelegator
    def initialize
      super(::Logger.new($stdout, level:, formatter:))
    end

    private

    def level
      Parking.options.verbose? ? "debug" : "info"
    end

    def formatter
      proc do |severity, _time, _progname, msg|
        abort("#{File.basename($PROGRAM_NAME)}: #{msg}".white.on_red) if severity == "FATAL"

        msg = "#{msg}\n"
        msg = msg.yellow if severity == "DEBUG"
        msg = msg.red if severity == "ERROR"

        msg
      end
    end
  end
end

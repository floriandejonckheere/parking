# frozen_string_literal: true

require "optparse"
require "English"

module Parking
  class CLI
    attr_reader :parser, :args, :command_args

    def initialize(args)
      @parser = OptionParser.new("#{File.basename($PROGRAM_NAME)} [global options] command") do |o|
        o.on("Global options:")
        o.on("--width=WIDTH", Integer, "Screen width")
        o.on("--height=WIDTH", Integer, "Screen height")
        o.on("--model=MODEL", "Car model (default 'car')")
        o.on("--automatic", "Park automatically")
        o.on("--algorithm=ALGORITHM", "Use algorithm")
        o.on("--algorithms", "Display algorithms") { algorithms }
        o.on("--layout=LAYOUT", "Use parking layout")
        o.on("--layouts", "Display parking layouts") { layouts }
        o.on("--[no-]damage", "Use damage in score calculation")
        o.on("--seed=SEED", "Set random seed") { |s| srand s }
        o.on("--debug", "Turn on debug logging")
        o.on("-h", "--help", "Display this message") { usage }
      end

      @args = args
      @command_args = []

      parse!
    end

    def parse!
      # Parse command line arguments (in order) and extract non-option arguments
      # (unrecognized option values). Raise for invalid option arguments (unrecognized
      # option keys). "--foo FOO --bar BAR" will result in "--foo" and "FOO" being parsed
      # correctly, "--bar" and "BAR" will be extracted.
      parser.order!(args, into: Parking.options) { |value| command_args << value }
    rescue OptionParser::InvalidOption => e
      @command_args += e.args
      retry
    end

    def start
      Parking::Application
        .new
        .start
    rescue UsageError => e
      # Don't print tail if no message was passed
      return usage if e.message == e.class.name

      usage(tail: "#{File.basename($PROGRAM_NAME)}: #{e.message}")
    rescue Error => e
      Parking.logger.fatal e.message
    end

    private

    def algorithms
      Parking.logger.info parser.to_s
      Parking.logger.info "Algorithms:"

      Parking::Algorithm.descendants.sort_by(&:name).each do |k|
        Parking.logger.info "    #{k.name.demodulize.underscore.ljust(20)}#{k.description}"
      end

      exit
    end

    def layouts
      Parking.logger.info parser.to_s
      Parking.logger.info "Layouts:"

      Dir[Parking.root.join("res/layouts/*.yml")].each do |layout|
        Parking.logger.info "    #{File.basename(layout, '.yml')}"
      end

      exit
    end

    def usage(code: 1, tail: nil)
      Parking.logger.info parser.to_s
      Parking.logger.info tail if tail

      raise ExitError, code
    end
  end
end

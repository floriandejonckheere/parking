# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(File.join(__dir__, "..", "lib"))

require "bundler/setup"

require "dotenv/load"

require "parking"

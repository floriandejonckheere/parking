# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.1"

gem "activesupport", ">= 6.0", "< 7.1"
gem "colorize", "~> 0.8"
gem "dotenv", "~> 2.7"
gem "zeitwerk", "~> 2.4"

group :development, :test do
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"

  gem "factory_bot"
  gem "ffaker"
  gem "overcommit"
  gem "pry-byebug"
  gem "rake"
  gem "rspec", "~> 3.10"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "super_diff"
end

# frozen_string_literal: true

if ENV['CI'] == 'true' || ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

require 'augury'

RSpec.configure do |config|
end

# frozen_string_literal: true

if ENV['CI'] == 'true' || ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

require 'augury'

require 'vcr'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  # Remove auth info from cassettes
  config.filter_sensitive_data('<AUTH>') do |interaction|
    auths = interaction.request.headers['Authorization'].first
    if (match = auths.match(/^(Basic|Bearer)\s+([^,\s]+)/))
      match.captures[1]
    end
  end

  config.filter_sensitive_data('<RAUTH>') do |interaction|
    response = JSON.parse(interaction.response.body)
    response['access_token'] if response.is_a? Hash
  end
end

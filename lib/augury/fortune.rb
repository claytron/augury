require 'twitter'
require 'parseconfig'

module Augury
  class Fortune
    def initialize
      # TODO: add a check for the file and warn the user
      @config = ParseConfig.new(File.expand_path('~/.augury.conf'))
      @twitter  = Twitter::REST::Client.new do |config|
        config.consumer_key = @config.params['consumer_key']
        config.consumer_secret = @config.params['consumer_secret']
        config.access_token = @config.params['access_token']
        config.access_token_secret = @config.params['access_token_secret']
      end
    end

    def tweet_texts(username='SeinfeldToday')
      @twitter.user_timeline(username).flat_map { |tweet| tweet.full_text }
    end
  end
end

require 'facets/string/word_wrap'
require 'parseconfig'
require 'twitter'
require 'wannabe_bool'

module Augury
  class Fortune
    def initialize(username, path, width=nil, append=nil)
      begin
        @config = ParseConfig.new(File.expand_path('~/.augury.cfg'))
      rescue Errno::EACCES
        @config = ParseConfig.new
      end

      augury_config = @config.params['augury'] || {}
      @username = username
      @path = path
      @width = width || augury_config['width'] || 72
      @append = append || augury_config['append'].to_b || false

      twitter_config = @config.params['twitter']
      raise Augury::TwitterConfigError unless twitter_config
      @twitter  = Twitter::REST::Client.new do |config|
        config.consumer_key = twitter_config['consumer_key']
        config.consumer_secret = twitter_config['consumer_secret']
        config.access_token = twitter_config['access_token']
        config.access_token_secret = twitter_config['access_token_secret']
      end
    end

    def tweet_texts
      @twitter.user_timeline(@username).flat_map { |tweet| tweet.full_text }
    end

    def format_fortune(tweets)
      tweets.flat_map { |tweet| tweet.word_wrap(@width) }.join("%\n")
    end

    def write_fortune(text)
      # Write out the file
      begin
        mode = @append ? 'a' : 'w'
        file = File.open(@path, mode)
        file.write("%\n") if @append
        file.write(text)
      rescue IOError => e
        puts e
      ensure
        file.close unless file.nil?
      end
      # Create the dat file too
      `strfile #{@path} #{@path}.dat`
    end
  end
end

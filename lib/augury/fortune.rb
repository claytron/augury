# frozen_string_literal: true

require 'facets/string/word_wrap'
require 'twitter'

module Augury
  class Fortune
    def initialize(username, path, config)
      @username = username
      @path = path
      @config = config
    end

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      if response.empty?
        collection.flatten
      elsif !@config[:count].zero? && collection.length >= @config[:count]
        collection.flatten
      else
        collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end

    def tweets
      collect_with_max_id do |max_id|
        options = {
          include_rts: true,
          count: @config[:count].zero? ? 200 : @config[:count],
        }
        options[:max_id] = max_id unless max_id.nil?
        @twitter.user_timeline(@username, options)
      end
    rescue Twitter::Error::TooManyRequests => e
      reset_length = e.rate_limit.reset_in + 1
      puts "Twitter rate limit exceeded. Waiting #{reset_length} minute(s)"
      sleep reset_length
    end

    def format_fortune
      tweet_texts = self.tweets.flat_map { |tweet| tweet.full_text }
      tweet_texts.flat_map { |tweet| tweet.word_wrap(@config[:width]) }.join("%\n")
    end

    def write_fortune
      text = self.format_fortune
      # Write out the file
      begin
        mode = @config[:append] ? 'a' : 'w'
        file = File.open(@path, mode)
        file.write(text)
        file.write("%\n") if @config[:append]
      ensure
        file.close unless file.nil?
      end
      # Create the dat file too
      `strfile '#{@path}' '#{@path}.dat'`
    end

    def twitter_setup
      raise Augury::TwitterConfigError unless @config[:twitter]

      @twitter = Twitter::REST::Client.new do |cfg|
        cfg.consumer_key = @config[:twitter]['consumer_key']
        cfg.consumer_secret = @config[:twitter]['consumer_secret']
        cfg.access_token = @config[:twitter]['access_token']
        cfg.access_token_secret = @config[:twitter]['access_token_secret']
      end
    end
  end
end

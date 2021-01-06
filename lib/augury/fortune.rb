# frozen_string_literal: true

require 'facets/string/word_wrap'
require 'parseconfig'
require 'twitter'
require 'wannabe_bool'

module Augury
  class Fortune
    def initialize(username, path, width=nil, append=nil, count=nil)
      begin
        @config = ParseConfig.new(File.expand_path('~/.augury.cfg'))
      rescue Errno::EACCES
        @config = ParseConfig.new
      end

      augury_config(username, path, width, append, count)
      twitter_config
    end

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      if response.empty?
        collection.flatten
      elsif ! @count.zero? && collection.length >= @count
        collection.flatten
      else
        collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end

    def tweets
      collect_with_max_id do |max_id|
        options = {
          count: @count.zero? ? 200 : @count,
          include_rts: true,
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
      tweet_texts.flat_map { |tweet| tweet.word_wrap(@width) }.join("%\n")
    end

    def write_fortune
      text = self.format_fortune
      # Write out the file
      begin
        mode = @append ? 'a' : 'w'
        file = File.open(@path, mode)
        file.write("%\n") if @append
        file.write(text)
      ensure
        file.close unless file.nil?
      end
      # Create the dat file too
      `strfile '#{@path}' '#{@path}.dat'`
    end

  private

    def augury_config(username, path, width, append, count)
      config = @config.params['augury'] || {}
      @username = username
      @path = path
      @width = (width || config['width'] || 72).to_i
      @append = (append || config['append'] || false).to_b
      @count = (count || config['count'] || 200).to_i
    end

    def twitter_config
      config = @config.params['twitter']
      raise Augury::TwitterConfigError unless config

      @twitter = Twitter::REST::Client.new do |cfg|
        cfg.consumer_key = config['consumer_key']
        cfg.consumer_secret = config['consumer_secret']
        cfg.access_token = config['access_token']
        cfg.access_token_secret = config['access_token_secret']
      end
    end
  end
end

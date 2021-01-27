# frozen_string_literal: true

require 'cgi'
require 'word_wrap'
require 'twitter'

module Augury
  class Fortune
    def initialize(username, path, config)
      @username = username
      @path = path
      @config = config
      @tweets = []
    end

    def collect_with_max_id(collection = [], max_id = nil, &block)
      response = yield(max_id)
      collection += response
      if response.empty?
        collection
      elsif !@config[:count].zero? && collection.length >= @config[:count]
        # Get everything or trim the results to the count
        @config[:count].zero? ? collection : collection[0..@config[:count] - 1]
      else
        collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end

    def retrieve_tweets
      @tweets = collect_with_max_id do |max_id|
        options = {
          count: 200,
          tweet_mode: 'extended',
          include_rts: @config[:retweets],
          exclude_replies: !@config[:replies],
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
      filtered = @tweets.flat_map(&:full_text).reject do |tweet|
        tweet.match(/https?:/) unless @config[:links]
      end
      to_transform = transforms
      formatted = filtered.flat_map do |tweet|
        text = CGI.unescapeHTML(tweet)
        to_transform.each do |transform|
          text.gsub!(transform[0], transform[1])
        end
        WordWrap.ww text, @config.fetch(:width, 72)
      end
      author = @config[:attribution] ? "\n-- #{@twitter.user(@username).name}\n" : ''
      text = formatted.join("#{author}%\n")
      text + author if author
    end

    def write_fortune
      # Write out the file
      begin
        mode = @config[:append] ? 'a' : 'w'
        file = File.open(@path, mode)
        file.write("%\n") if @config[:append]
        file.write(format_fortune)
      ensure
        file&.close
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

    private

    def transforms
      all_transforms = []
      all_transforms << [/https?:\/\/[^\s]+/, ''] if @config[:remove_links]
      return all_transforms unless @config[:apply_transforms]

      all_transforms.push(*@config.dig('transforms', @username) || [])
      all_transforms.push(*@config.fetch('global-transforms', []))

      raise Augury::TransformError unless validate_transforms(all_transforms)

      all_transforms
    end

    def validate_transforms(all_transforms)
      all_transforms.all? do |transform|
        transform.count == 2 &&
          [String, Regexp].include?(transform[0].class) &&
          transform[1].is_a?(String)
      end
    end
  end
end

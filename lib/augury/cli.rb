# frozen_string_literal: true

require 'thor'
require 'yaml'
require 'augury'

module Augury
  class CLI < Thor
    desc 'generate USERNAME [PATH]', 'Generate a fortune file for the given username'

    option :width,
      type: :numeric,
      aliases: '-w',
      desc: 'The maximum number of columns that will be written on a line. DEFAULT: 72'

    option :append,
      type: :boolean,
      aliases: '-a',
      desc: 'If set, the target path will be appended to instead of overwritten. DEFAULT: false'

    option :count,
      type: :numeric,
      aliases: '-c',
      desc: 'The number of tweets to get. Set to 0 to get all. DEFAULT: 200'

    option :retweets,
      type: :boolean,
      aliases: '-r',
      desc: 'Include retweets. DEFAULT: false'

    option :replies,
      type: :boolean,
      aliases: '-R',
      desc: 'Include replies. DEFAULT: false'

    option :links,
      type: :boolean,
      aliases: '-l',
      desc: 'Include tweets with links in them. DEFAULT: false'

    option :remove_links,
      type: :boolean,
      aliases: '--remove-links',
      desc: 'Remove links from tweets. DEFAULT: false'

    option :attribution,
      type: :boolean,
      aliases: '-A',
      desc: 'Add an author attribution to each fortune. DEFAULT: false'

    option :apply_transforms,
      type: :boolean,
      aliases: '-t',
      desc: 'Apply transforms from config file. DEFAULT: false'

    option :debug,
      type: :boolean,
      aliases: '-d',
      hide: true

    def generate(username, *path)
      path = File.expand_path(path[0] || username)
      augury = Augury::Fortune.new(username, path, options)
      augury.twitter_setup
      augury.retrieve_tweets
      augury.write_fortune
      say "Fortune written out to #{path}"
    rescue StandardError => e
      say 'There was an error running the command. Details below:'
      say e.message
      puts e.backtrace if options[:debug]
      exit 1
    end

    private

    # TODO: This override doesn't work in Thor 1.1+
    def options
      original_options = super
      defaults = Thor::CoreExt::HashWithIndifferentAccess.new(
        {
          width: 72,
          count: 200,
        },
      )

      config_path = File.expand_path(ENV.fetch('AUGURY_CFG_PATH', '~/.augury.yml'))
      if File.file?(config_path)
        config_options = Thor::CoreExt::HashWithIndifferentAccess.new(YAML.load_file(config_path) || {})
        defaults = defaults.merge(config_options)
      end

      # Enforce implied options
      defaults[:links] = true if original_options[:remove_links] || defaults[:remove_links]

      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
  end
end

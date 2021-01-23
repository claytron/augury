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
      desc: 'If set, the target path will be appended to instead of overwritten'

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

    option :attribution,
      type: :boolean,
      aliases: '-A',
      desc: 'Add an author attribution to each fortune. DEFAULT: false'

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
      exit 1
    end

    private

    def options
      original_options = super
      defaults = Thor::CoreExt::HashWithIndifferentAccess.new(
        {
          width: 72,
          append: false,
          count: 200,
          retweets: false,
          replies: false,
          links: false,
          attribution: false,
        },
      )

      config_path = File.expand_path(ENV.fetch('AUGURY_CFG_PATH', '~/.augury.yml'))
      if File.file?(config_path)
        config_options = Thor::CoreExt::HashWithIndifferentAccess.new(YAML.load_file(config_path) || {})
        defaults = defaults.merge(config_options)
      end

      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
  end
end

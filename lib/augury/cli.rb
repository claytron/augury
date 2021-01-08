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

    def generate(username, *path)
      path = File.expand_path(path[0] || username)
      augury = Augury::Fortune.new(username, path, options)
      augury.twitter_setup
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
        },
      )

      config_path = File.expand_path('~/.augury.yml')
      if File.file?(config_path)
        config_options = Thor::CoreExt::HashWithIndifferentAccess.new(YAML.load_file(config_path) || {})
        defaults = defaults.merge(config_options)
      end

      Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
  end
end

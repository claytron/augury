require 'thor'
require 'augury'

module Augury
  class CLI < Thor
    desc 'generate USERNAME [PATH]', 'Generate a fortune file for the given username'
    option :width,
      :type => :numeric, :aliases => '-w', :default => 72,
      :desc => 'The maximum number of columns that will be written on a line.'
    option :append,
      :type => :boolean, :aliases => '-a',
      :desc => 'If set, the target path will be appended to instead of overwritten'
    def generate(username, *path)
      path = File.expand_path(path[0] || username)
      begin
        augury = Augury::Fortune.new(
          username,
          path,
          options['width'],
          options['append']
        )
      rescue Augury::TwitterConfigError => e
        puts e.message
        exit 1
      end
      tweets = augury.tweet_texts
      augury.write_fortune(augury.format_fortune(tweets))
      self.say "Fortune written out to #{path}"
    end
  end
end

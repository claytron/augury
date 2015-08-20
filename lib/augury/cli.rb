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
      begin
        path = File.expand_path(path[0] || username)
          augury = Augury::Fortune.new(
            username,
            path,
            options['width'],
            options['append']
          )
        tweets = augury.tweet_texts
        augury.write_fortune(augury.format_fortune(tweets))
        self.say "Fortune written out to #{path}"
      rescue => e
        self.say "There was an error running the command. Details below:"
        self.say e.message
        exit 1
      end
    end
  end
end

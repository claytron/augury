require 'thor'
require 'augury'

module Augury
  class CLI < Thor
    desc 'generate USERNAME', 'Generate a fortune file for the given username'
    def generate(username)
      augury = Augury::Fortune.new
      puts augury.tweet_texts(username)
    end
  end
end

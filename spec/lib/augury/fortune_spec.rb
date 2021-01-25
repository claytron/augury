# frozen_string_literal: true

require 'spec_helper'
require 'open3'

describe Augury::Fortune do
  context 'fortune' do
    let(:output_dir) { Dir.mktmpdir('augury-tests-') }

    after do
      FileUtils.rm_rf(output_dir)
    end

    let(:twitter_auth) do
      {
        twitter: {
          'consumer_key' => ENV['TWITTER_CONSUMER_KEY'],
          'consumer_secret' => ENV['TWITTER_CONSUMER_SECRET'],
          'access_token' => ENV['TWITTER_ACCESS_TOKEN'],
          'access_token_secret' => ENV['TWITTER_ACCESS_TOKEN_SECRET'],
        },
      }
    end

    it 'fetches all for user', :vcr do
      config = twitter_auth.merge({ count: 0, replies: true, retweets: true, links: true })
      augury = Augury::Fortune.new('seinfeldtoday', 'seinfeldtoday', config)
      augury.twitter_setup
      tweets = augury.retrieve_tweets
      # Twitter UI says 510, not sure what I'm missing...
      expect(tweets.count).to eq 506
    end

    it 'fetches 300 for user', :vcr do
      config = twitter_auth.merge({ count: 300 })
      augury = Augury::Fortune.new('seinfeldtoday', 'seinfeldtoday', config)
      augury.twitter_setup
      tweets = augury.retrieve_tweets
      expect(tweets.count).to eq 300
    end

    it 'writes to filesystem', :vcr do
      config = twitter_auth.merge({ count: 3 })
      augury = Augury::Fortune.new('boredelonmusk', "#{output_dir}/boredelonmusk", config)
      augury.twitter_setup
      augury.retrieve_tweets
      augury.write_fortune
      expect(File).to exist("#{output_dir}/boredelonmusk")
      expect(File).to exist("#{output_dir}/boredelonmusk.dat")
    end

    it 'outputs', :vcr do
      config = twitter_auth.merge({ count: 1 })
      augury = Augury::Fortune.new('drunkhulk', "#{output_dir}/drunkhulk", config)
      augury.twitter_setup
      augury.retrieve_tweets
      augury.write_fortune
      stdout, stderr, status = Open3.capture3('fortune', "#{output_dir}/drunkhulk")
      expect(stderr).not_to eq "No fortunes found\n"
      expect(status.success?).to be
      # Ensure that fortunes are being output
      expect(stdout.empty?).not_to be
    end
  end
end

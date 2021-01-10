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
          'token_secret' => ENV['TWITTER_ACCESS_TOKEN_SECRET'],
        },
      }
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
      output, res = Open3.capture2('fortune', "#{output_dir}/drunkhulk")
      expect(res.success?)
      expect(output).to eq "FUCK THIS!\n"
    end
  end
end

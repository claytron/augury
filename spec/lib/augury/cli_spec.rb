# frozen_string_literal: true

require 'spec_helper'
require 'augury/cli'

describe Augury::CLI do
  context 'start' do
    it 'runs and outputs help' do
      expect { Augury::CLI.start(%w[help generate]) }.to output(
        /Generate a fortune file for the given username/,
      ).to_stdout
    end
  end

  context 'options' do
    it 'has defaults' do
      ENV['AUGURY_CFG_PATH'] = '/nil'
      expect(subject.send(:options)).to eq(
        {
          'width' => 72,
          'count' => 200,
        },
      )
    end

    it 'args override defaults' do
      ENV['AUGURY_CFG_PATH'] = '/nil'
      expect(Augury::CLI.new([], count: 0, width: 500, replies: true).send(:options)).to eq(
        {
          'width' => 500,
          'count' => 0,
          'replies' => true,
        },
      )
    end

    it 'reads from config' do
      ENV['AUGURY_CFG_PATH'] = 'spec/fixtures/overrides.yml'
      expect(subject.send(:options)).to eq(
        {
          'width' => 500,
          'append' => true,
          'count' => 0,
          'retweets' => true,
          'replies' => true,
          'links' => true,
          'attribution' => true,
        },
      )
    end

    it 'args take precedence over config' do
      ENV['AUGURY_CFG_PATH'] = 'spec/fixtures/overrides.yml'
      expect(Augury::CLI.new([], count: 10, width: 50).send(:options)).to eq(
        {
          'width' => 50,
          'append' => true,
          'count' => 10,
          'retweets' => true,
          'replies' => true,
          'links' => true,
          'attribution' => true,
        },
      )
    end

    it 'sets links if remove_links is set' do
      ENV['AUGURY_CFG_PATH'] = '/nil'
      expect(Augury::CLI.new([], remove_links: true).send(:options)).to include(
        {
          'remove_links' => true,
          'links' => true,
        },
      )
    end

    it 'sets links if remove_links is set in config' do
      ENV['AUGURY_CFG_PATH'] = 'spec/fixtures/remove_links.yml'
      expect(subject.send(:options)).to include(
        {
          'remove_links' => true,
          'links' => true,
        },
      )
    end

    it 'allows regex in transforms' do
      ENV['AUGURY_CFG_PATH'] = 'spec/fixtures/transforms.yml'
      expect(subject.send(:options)).to include(
        {
          'global-transforms' => [[/(hello)/i, '\\1 world']],
        },
      )
    end
  end
end

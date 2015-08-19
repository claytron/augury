# Augury

Have you ever wanted to turn a twitter account into an updating fortune file?
Well, today is your lucky day!
Augury can take a twitter feed and turn it into a fortune file for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'augury'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install augury

## Configuration

First, you will need to create a new Twitter application by going here:

https://apps.twitter.com

This will give you the ability to generate the consumer and access information used below.

In order to use this gem, you need to set up your Twitter credentials.
This can be done by setting up the `~/.augury.conf` file.
Here is an example of its contents:

  consumer_key = "YOUR_CONSUMER_KEY"
  consumer_secret = "YOUR_CONSUMER_SECRET"
  access_token = "YOUR_ACCESS_TOKEN"
  access_token_secret = "YOUR_ACCESS_SECRET"

Make sure only your user has access to the file:

  $ chmod 600 ~/.augury.conf

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`,
which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/claytron/augury.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

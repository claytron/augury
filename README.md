# Augury

Have you ever wanted to turn a twitter account into a fortune file?
Well, today is your lucky day!

Here is an example:

```
$ augury generate SeinfeldToday
```

This just created the fortune files in the current directory:

```
$ ls
SeinfeldToday SeinfeldToday.dat
```

You can now read the new fortunes!

```
$ fortune SeinfeldToday
Elaine has no idea what her BF does for a living and it's now too
late to ask. E:"Teacher, I think. Or a doctor? Wait Is
'computers' a job?"
```

Thanks for all the laughs fortune :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'augury'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install augury
```

### Requirements

This gem requires that the fortune program is also installed.
The fortune program ships with a `strfile` program that converts the plain text files to something that fortune can select from.

For example,
if you are using Homebrew on OS X:

```
$ brew install fortune
```

## Configuration

### Augury Config

Create the `~/.augry.cfg` file and then set the permissions since your Twitter API info will be in there.

```sh
$ touch ~/.augury.cfg
$ chmod 600 ~/.augury.cfg
```

Set any of these settings in the `augury` section of the config like this:

```ini
[augury]
example_option = "An interesting value"
```

### Option list

These are the available options for the `~/.augury.cfg`

- `append` Make the script add more entries to the specified file instead of re-writing it. DEFAULT: False
- `width` Set the default width used if none is given on the command line. DEFAULT: 72

### Twitter Setup

First, you will need to create a new Twitter application by going here:
https://apps.twitter.com

This will give you the ability to generate the consumer and access information used below.

Add the following to your `~/.augury.cfg` file.

```ini
[twitter]
consumer_key = "YOUR_CONSUMER_KEY"
consumer_secret = "YOUR_CONSUMER_SECRET"
access_token = "YOUR_ACCESS_TOKEN"
access_token_secret = "YOUR_ACCESS_SECRET"
```

## Usage

Create a fortune for the latest SeinfeldToday tweets.

```
$ augury generate SeinfeldToday
```

Now you have some fortunes.

```
$ fortune SeinfeldToday
```

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

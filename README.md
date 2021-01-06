# Augury

[![Code Climate](https://codeclimate.com/github/claytron/augury/badges/gpa.svg)](https://codeclimate.com/github/claytron/augury)
[![Tests](https://travis-ci.com/claytron/augury.svg?branch=master)](https://travis-ci.com/github/claytron/augury)

Have you ever wanted to turn a twitter account into a fortune file?
Well, today is your lucky day!

<blockquote>
Augury is the practice from ancient Roman religion of<br>
interpreting omens from the observed flight of birds.<br><br>
As per <a href="https://en.wikipedia.org/wiki/Augury">Wikipedia</a>
</blockquote>

There are a lot of really funny twitter accounts out there.
Let's just pick one and get started.

```
$ augury generate seinfeldtoday
```

This just created the fortune files in the current directory:

```
$ ls
seinfeldtoday seinfeldtoday.dat
```

You can now read the new fortunes!

```
$ fortune seinfeldtoday
Elaine has no idea what her BF does for a living and it's now too
late to ask. E:"Teacher, I think. Or a doctor? Wait Is
'computers' a job?"
```

Thanks for all the laughs fortune :)

Here are some accounts that work well with Augury:

- [Modern Seinfeld](https://twitter.com/seinfeldtoday)
- [Very Short Story](https://twitter.com/veryshortstory)
- [Bored Elon Musk](https://twitter.com/boredelonmusk)
- Your own feed, so you can get nostalgic.

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

Option | Description | Default
------ | :---------- | -------
`append` | Make the script add more entries to the specified file instead of re-writing it | `false`
`width` | Set the default width used if none is given on the command line. | `72`
`count` | The number of tweets to get. Set to 0 to get all. | `200`

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

Create a fortune for the latest *seinfeldtoday* tweets.

```
$ augury generate seinfeldtoday
```

Now you have some fortunes.

```
$ fortune seinfeldtoday
```

Specify a width and a different path to use:

```
$ augury generate -w 120 seinfeldtoday /usr/local/share/games/fortune/Modern\ Seinfeld
```

If this is where your fortune program looks for fortunes,
you can now use the new fortune.

```
$ fortune "Modern Seinfeld"
```

### See the interactive help

Run the help to get more details about what the program can do

```
$ bin/augury help
$ bin/augury help generate
```

## Development

If you want to contribute to this library,
do the following.

Create a fork, then get the code

```
$ git clone git@github.com:YOUR_USERNAME/augury.git
$ cd augury
```

Run the setup script to get everything installed:

**NOTE**: This requires having bundler available.
That is beyond the scope of this README.

```
$ bin/setup
```

Once that is finished, there is a console available.
This gives you access to all the code via Pry.

```
$ bin/console
```

The `augury` command will be available in bin:

```
$ bin/augury help
```

### Run the tests

You can run the tests with the rake task:

```
$ rake spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/claytron/augury.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Thanks for all the fish

Thanks to [TinderBox](http://gettinderbox.com) for giving us time to make cool things happen!

This was an excellent learning experience for the author,
who was new at programming in Ruby.

The [Developing a RubyGem using Bundler][gemdocs] documentation was fun to read and informative.
It helped get the skeleton of the code set up and extra goodies in the development profile.
Highly recommended read!

[gemdocs]: https://github.com/radar/guides/blob/master/gem-development.md#developing-a-rubygem-using-bundler

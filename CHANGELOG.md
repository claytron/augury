# Changes

## 2.0.0 (2024-03-05)

- Test against latest Ruby 3.3 and minimum 3.1.x

## 1.2.0 (2022-10-26)

- Test against latest Ruby 3.1, minimum version 2.7

## 1.1.2 (2022-04-12)

- Fix issue with mismatched case for Twitter screen_name. (#22)

## 1.1.1 (2020-02-13)

- Fix attribution on last item
- More test coverage for formatting
- Add hidden debug option

## 1.1.0 (2020-01-24)

- Add ability to transform tweet text with find / replace
- Get full text of tweets, not the default abbreviated version
- Switch to better word wrapping library

## 1.0.3 (2020-01-23)

- Pin Thor version to avoid issue with `options` override
- Add tests for `Augury::CLI`

## 1.0.2 (2020-01-09)

- Fix bug with specific tweet count retrieval

## 1.0.1 (2020-01-08)

- Remove unused gem

## 1.0.0 (2020-01-08)

- Convert augury config from ini style to yaml (breaking change)
- Add options for filtering out tweets (retweets, replies, links)
- Add option to show twitter user name as an attribution
- Ensure output has not html entities in it

## 0.3.0 (2015-08-20)

- Add `count` option and allow for a user to get all tweets
- Improve error handling
- Handle spaces in `path` argument
- Properly get defaults from the config if not passed on the command line
- Updated docs and interactive help

## 0.2.1 (2015-08-19)

- Fix docs on rubygems site

## 0.2.0 (2015-08-19)

- Initial working code and documentation

## 0.1.0 (2015-08-19)

- Initial code skeleton
- Test push to rubygems

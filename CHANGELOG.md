# Changes

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

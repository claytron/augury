# frozen_string_literal: true

require_relative 'lib/augury/version'

Gem::Specification.new do |spec|
  spec.name          = 'augury'
  spec.version       = Augury::VERSION
  spec.authors       = ['Clayton Parker']
  spec.email         = ['robots@claytron.com']

  spec.summary       = 'Turn a twitter feed into a fortune file'
  spec.description   = 'This gem turns a twitter feed into a fortune file that you can use with the fortune program'
  spec.homepage      = 'https://github.com/claytron/augury'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Actual dependencies
  spec.add_dependency 'thor', '~>1.0'
  spec.add_dependency 'twitter', '~>7.0'
  ## For the word_wrap function
  spec.add_dependency 'facets', '~>3.0'
end

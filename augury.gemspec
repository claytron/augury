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
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1')

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Actual dependencies
  # TODO: The options override in Augury::CLI doesn't work in Thor 1.1+
  spec.add_dependency 'thor', '~>1.0.0'
  spec.add_dependency 'twitter', '~>7.0'
  ## For the word_wrap function
  spec.add_dependency 'word_wrap', '~>1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end

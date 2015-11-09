# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'augury/version'

Gem::Specification.new do |spec|
  spec.name          = 'augury'
  spec.version       = Augury::VERSION
  spec.authors       = ['Clayton Parker']
  spec.email         = ['robots@claytron.com']

  spec.summary       = %q{Turn a twitter feed into a fortune file}
  spec.description   = %q{This gem turns a twitter feed into a fortune file that you can use with the fortune program}
  spec.homepage      = 'https://github.com/claytron/augury'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Actual dependencies
  spec.add_dependency 'parseconfig'
  spec.add_dependency 'thor'
  spec.add_dependency 'twitter'
  ## Handle booleans from simple config
  spec.add_dependency 'wannabe_bool'
  ## For the word_wrap function
  spec.add_dependency 'facets'
  ## To test mutation station :)
  spec.add_dependency 'rspec', '3.2.0'

  # Development dependencies
  ## Setup
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  ## Testing
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'aruba'
  ## Debugging
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-awesome_print'
end

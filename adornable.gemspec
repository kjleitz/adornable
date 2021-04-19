# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "adornable/version"

Gem::Specification.new do |spec|
  spec.name = "adornable"
  spec.version = Adornable::VERSION
  spec.authors = ["Keegan Leitz"]
  spec.email = ["kjleitz@gmail.com"]

  spec.summary = "Method decorators for Ruby"
  spec.description = "Adornable provides the ability to cleanly decorate methods in Ruby. You can make and use your own decorators, and you can also use some of the built-in ones that the gem provides. _Decorating_ methods is as simple as slapping a `decorate :some_decorator` above your method definition. _Defining_ decorators can be as simple as defining a method that yields to a block, or as complex as manipulating the decorated method's receiver and arguments, and/or changing the functionality of the decorator based on custom options supplied to it when initially applying the decorator." # rubocop:disable Layout/LineLength
  spec.homepage = "https://github.com/kjleitz/adornable"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.7"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.10"
  spec.add_development_dependency "rubocop-performance", "~> 1.9"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-rspec", "~> 2.2"
  spec.add_development_dependency "solargraph"
end

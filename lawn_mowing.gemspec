# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lawn_mowing/version'

Gem::Specification.new do |spec|

    spec.date        = '2006-03-05'
    spec.summary     = "Lawn mowing"

 

    # spec.files       = ["lib/lawn_mowing.rb"]
    # spec.homepage    = 'http://rubygems.org/gems/hello_anderson'



  spec.name          = "lawn_mowing"
  spec.version       = LawnMowing::VERSION
  spec.authors     = ["Anderson Araujo Lopes"]
  spec.description = "Lawn mowing test"
  spec.date = Date.today
  spec.email         = ["romalopes@yahoo.com.br"]

  spec.homepage      = "http://www.github.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.files       = ["lib/lawn_mowing.rb", "lib/mower.rb"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end


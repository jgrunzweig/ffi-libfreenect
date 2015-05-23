# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freenect/version'

Gem::Specification.new do |spec|
  spec.name          = "ffi-libfreenect"
  spec.version       = Freenect::VERSION
  spec.authors       = ["Josh Grunzweig", "Eric Monti"]
  spec.summary       = %Q{FFI bindings for the libfreenect OpenKinect library}
  spec.description   = spec.summary
  spec.homepage      = "http://github.com/jgrunzweig/ffi-libfreenect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.rdoc_options  += ["--title", "FFI Freenect", "--main",  "README.rdoc", "--line-numbers"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "byebug"

  spec.add_dependency("ffi", ">= 0.5.0")
end

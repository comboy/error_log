# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'error_log/version'

Gem::Specification.new do |s|
  s.name        = "error_log"
  s.version     = ErrorLog::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kacper Ciesla"]
  s.email       = ["kacper.ciesla@gmail.com"]
  #s.homepage    = ""
  s.summary     = "Easy way to handle errors and warnings in rails apps"
  s.description = "Who cares about description, nobody reads it anyway."

  s.add_dependency('haml')

  s.files        = Dir.glob("{lib,views}/**/*") + %w(README.txt Changelog.txt)
  s.require_path = 'lib'
end

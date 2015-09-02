# -*- encoding: utf-8 -*-
#$:.push File.expand_path("../lib", __FILE__)
#require 'open_project/WikiExtension/version'

Gem::Specification.new do |s|
  s.name = "openproject_wiki_extension_plugin"
  s.version = "4.0.2"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]  
  
  s.authors = "Marcus Drobisch"
  s.email = "m.drobisch@googlemail.com"
  s.homepage = "https://github.com/blinzelaffe/openproject_wiki_extention_pulgin"
  s.date = "2015-03-25"
  s.summary = "OpenProject Wiki Extention"
  s.description = "Extending wiki formating macros"
  s.license = "GPLv3"
  
  #s.files = Dir["{app,config,db,doc,lib,vendor}/**/*"] + %w(README.md)
  s.files = Dir["{lib}/**/*"] + %w(README.md)

  s.add_dependency(%q<rails>, ["~> 3.2.9"])
end
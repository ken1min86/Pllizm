# -*- encoding: utf-8 -*-
# stub: jsonapi-rspec 0.0.11 ruby lib

Gem::Specification.new do |s|
  s.name = "jsonapi-rspec".freeze
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lucas Hosseini".freeze]
  s.date = "2020-12-19"
  s.description = "Helpers for validating JSON API payloads".freeze
  s.email = ["lucas.hosseini@gmail.com".freeze]
  s.homepage = "https://github.com/jsonapi-rb/jsonapi-rspec".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.25".freeze
  s.summary = "RSpec matchers for JSON API.".freeze

  s.installed_by_version = "3.2.25" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rspec-core>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<rspec-expectations>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rspec-core>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-expectations>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end

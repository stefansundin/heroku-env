require File.expand_path("../lib/heroku_env/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "heroku_env"
  s.version     = HerokuEnv::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stefan Sundin"]
  s.email       = ["stefan@stefansundin.com"]
  s.homepage    = "https://github.com/stefansundin/heroku_env"
  s.summary     = "Don't worry about the environment."
  s.description = "This gem automatically promotes Heroku addons' environment settings."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rake", "10.4.2"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

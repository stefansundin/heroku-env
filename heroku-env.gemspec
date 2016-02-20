require File.expand_path("../lib/heroku-env/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "heroku-env"
  s.version     = HerokuEnv::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stefan Sundin"]
  s.email       = ["rubygems@stefansundin.com"]
  s.homepage    = "https://github.com/stefansundin/heroku-env"
  s.summary     = "Don't worry about the environment."
  s.description = "This gem automatically promotes Heroku addons' environment settings. See the GitHub page for usage."
  s.license     = "GPL-3.0"

  s.cert_chain  = ["certs/stefansundin.pem"]
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rake"

  s.files        = `git ls-files lib`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

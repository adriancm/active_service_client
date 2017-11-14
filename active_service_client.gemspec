$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_service_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_service_client"
  s.version     = ActiveServiceClient::VERSION
  s.authors     = ["adriancm"]
  s.email       = ["adrian.cepillo@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActiveServiceClient."
  s.description = "TODO: Description of ActiveServiceClient."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
end

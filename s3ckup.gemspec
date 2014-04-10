$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3ckup/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3ckup"
  s.version     = S3ckup::VERSION
  s.authors     = ["Tiago Scolari"]
  s.email       = ["tscolari@gmail.com"]
  s.homepage    = "https://github.com/tscolari/s3ckup"
  s.summary     = "Folders to s3 backuping tool."
  s.description = "Manages incremental backups of files, soring on s3."
  s.executables = ["s3ckup"]

  s.files = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "aws-s3"

  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry-nav"
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rx}
  s.version = "0.0.1"
  s.authors = ["Tim Bray", "Charles Oliver Nutter"]
  s.date = Time.now.strftime('%Y-%m-%d')
  s.description = %q{A pure-Ruby XML parser that doesn't quietly allow invalid XML}
  s.email = ["twbray@google.com", "headius@headius.com"]
  s.files = Dir['{lib,examples}/**/*'] + Dir['{*.md,*.gemspec,Rakefile}']
  s.homepage = %q{http://github.com/headius/rx}
  s.require_paths = ["lib"]
  s.summary = s.description
end

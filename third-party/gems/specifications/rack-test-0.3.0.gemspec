# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-test}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryan Helmkamp"]
  s.date = %q{2009-05-16}
  s.description = %q{Simple testing API built on Rack}
  s.email = %q{bryan@brynary.com}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE.txt"]
  s.files = ["History.txt", "Rakefile", "README.rdoc", "lib/rack/mock_session.rb", "lib/rack/test/cookie_jar.rb", "lib/rack/test/methods.rb", "lib/rack/test/mock_digest_request.rb", "lib/rack/test/uploaded_file.rb", "lib/rack/test/utils.rb", "lib/rack/test.rb", "MIT-LICENSE.txt"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/brynary/rack-test}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple testing API built on Rack}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

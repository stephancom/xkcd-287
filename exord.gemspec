lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exord/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name          = 'exord'
  spec.version       = Exord::VERSION
  spec.authors       = ['stephan.com']
  spec.email         = ['stephan@stephan.com']

  spec.summary       = 'Solution for XKCD 287'
  spec.description   = 'Exact Orders: Given a menu and a target total, come up with all possible combinations of menu items that meet that total exactly'
  spec.homepage      = 'https://github.com/stephancom/xkcd-287'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.5.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://gems.stephan.com/'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/stephancom/xkcd-287'
    spec.metadata['changelog_uri'] = 'https://github.com/stephancom/xkcd-287/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'methadone', '~> 2.0.0'
  spec.add_dependency 'monetize', '~> 1.9.0'
  spec.add_dependency 'terminal-table', '~> 1.8.0'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.60.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end

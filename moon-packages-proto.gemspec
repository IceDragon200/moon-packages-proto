Gem::Specification.new do |s|
  s.name        = 'moon-packages-proto'
  s.summary     = 'Moon Experimental Packages'
  s.description = 'Moon-Player experimental Packages.'
  s.homepage    = 'https://github.com/IceDragon200/moon-packages-proto'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = '0.0.0'
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Blaž Hrastnik', 'Corey Powell']

  s.add_dependency             'rake',    '~> 10.3'
  s.add_dependency             'moon-inflector',    '~> 1.0'
  s.add_dependency             'moon-prototype',    '~> 1.0'
  s.add_dependency             'moon-serializable', '~> 1.0'
  s.add_development_dependency 'rubocop',      '~> 0.27'
  s.add_development_dependency 'yard',         '~> 0.8'
  s.add_development_dependency 'rspec',        '~> 3.2'
  s.add_development_dependency 'guard',        '~> 2.8'
  s.add_development_dependency 'guard-rspec', '~> 4.5'
  s.add_development_dependency 'guard-yard',  '~> 2.1'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'simplecov'

  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('lib/**/*.{rb,yml}')
  s.files += Dir.glob('spec/**/*')
end
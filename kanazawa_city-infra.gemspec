# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kanazawa_city/infra/version'

Gem::Specification.new do |gem|
  gem.name          = "kanazawa_city-infra"
  gem.version       = KanazawaCity::Infra::VERSION
  gem.authors       = ["Keisuke KITA"]
  gem.email         = ["kei.kita2501@gmail.com"]
  gem.description   = %q{Simple access KanazawaCity infra API}
  gem.summary       = %q{Simple access KanazawaCity infra API}
  gem.homepage      = "https://github.com/kitak/kanazawa_city-infra"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'hashie', "= 1.2.0"
end

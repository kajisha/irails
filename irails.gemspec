require_relative 'lib/irails/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'irails'
  s.date          = Date.today.to_s
  s.version       = IRails::VERSION
  s.authors       = ['Hiroshi Kajisha', 'Daniel Mendler', 'The SciRuby developers']
  s.email         = ['kajisha@gmail.com', 'mail@daniel-mendler.de']
  s.summary       = 'Rails Kernel for Jupyter'
  s.description   = 'A Rails kernel for Jupyter frontends (e.g. notebook). Try it at try.jupyter.org.'
  s.homepage      = 'https://github.com/kajisha/irails'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = %w(lib)

  m = "Consider installing the optional dependencies to get additional functionality:\n"
  File.read('Gemfile').scan(/gem\s+'(.*?)'/) { m << "  * #{$1}\n" }
  s.post_install_message = m << "\n"

  s.required_ruby_version = '>= 2.1.0'

  s.add_development_dependency 'rake', '>= 10.4'
  s.add_development_dependency 'minitest', '>= 5.6'

  s.add_runtime_dependency 'bond', '>= 0.5'
  s.add_runtime_dependency 'rbczmq', '>= 1.7'
  s.add_runtime_dependency 'multi_json', '>= 1.11'
  s.add_runtime_dependency 'mimemagic', '>= 0.3'
  s.add_runtime_dependency 'rails'
end

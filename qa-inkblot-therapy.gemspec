Gem::Specification.new do |spec|
  spec.name = 'inkblot-therapy-web-automation'
  spec.version = '1.0'
  spec.summary = "Inkblot Therapy Web Automation. Version #{spec.version}"
  spec.authors = ['Luis Vieira']
  spec.required_ruby_version = '>=2.5'

  spec.add_dependency 'webdrivers', '~> 5.2'
  spec.add_dependency 'httparty'
  spec.add_dependency 'capybara'
  spec.add_dependency 'selenium-webdriver', '~> 4.4.0'
  spec.add_dependency 'cucumber', '5.1.0'
  spec.add_dependency 'parallel_tests', '3.1.0'
  spec.add_dependency 'cuke_modeler', '~> 3.0'
  spec.add_dependency 'rspec', '3.9.0'
  spec.add_dependency 'rake'
  spec.add_dependency 'report_builder', '1.9'
  spec.add_dependency 'faker'
  spec.add_dependency 'pry'
  spec.add_dependency 'logger'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'testrail-ruby', '~> 0.1.02'
end
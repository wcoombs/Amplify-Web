source 'https://rubygems.org'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'webpacker'
gem "email_validator"
gem 'httparty'

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
end

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',   require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'webmock'
  gem 'vcr'
end

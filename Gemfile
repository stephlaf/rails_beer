# frozen_string_literal: true

Deprecate.skip = true if defined?(Deprecate.skip)
Gem::Deprecate.skip = true if defined?(Gem::Deprecate.skip)

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails' 6.1.7.3
gem 'rails', '6.1.7.3'

gem 'pg'
# Use Puma as the app server
gem 'puma', '>= 5.6.7'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', '>= 1.4.2', require: false

# Custom
gem 'airtable'
gem 'autoprefixer-rails'
gem 'cloudinary', '~> 1.16.0'
gem 'devise'
gem 'font-awesome-sass', '~> 5.6.1'
gem 'pg_search', '~> 2.3.0'
gem 'simple_form'
gem 'turbolinks_render'

gem 'dotenv-rails', groups: %i[development test]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rubocop', '~> 1.57', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

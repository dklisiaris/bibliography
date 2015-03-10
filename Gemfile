source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# modernizr.js lib
gem 'modernizr-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'  

  gem 'rspec-rails'
  gem 'factory_girl_rails'  
end

group :test do
  gem "faker"
  gem "capybara"
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
end

gem 'bootstrap-sass'
gem 'autoprefixer-rails'

group :development do
  gem 'rails_layout'
end

group :production do
  gem 'pg'
end

gem 'dotenv-rails'

# Authentication
gem 'devise'

# User roles
gem 'royce'

# Authorization
gem "pundit"

# For models with tree parent-child associations
gem 'acts_as_tree', '~> 2.1.0'

# Uploaders
gem 'carrierwave'

# Json support
gem 'json'

# Pagination
gem 'kaminari'

# Search engine gem on top of elasticsearch
gem 'searchkick'

# jQuery plugin for drop-in fix binded events problem caused by Turbolinks
gem 'jquery-turbolinks'

# Runs HTTP requests in parallel while cleanly encapsulating handling logic.
gem 'typhoeus'

# Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting, Rails related I18n stuff
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x

# A fast and very simple Ruby web server
gem 'thin'
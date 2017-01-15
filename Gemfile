source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use mysql as the database for Active Record
# gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# modernizr.js lib
gem 'modernizr-rails', '~> 2.7'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# High Performance Haml Implementation
gem 'hamlit-rails', '~> 0.1.0'

# Cells allow you to encapsulate parts of your page into separate MVC components
gem 'cells', "4.0.0.beta3"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 8.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.3'

  gem 'rspec-rails', '~> 3.2'
  gem 'factory_girl_rails', '~> 4.5'

  gem 'better_errors', '~> 2.1', '>= 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'pry-rescue'

  # gem "rspec-cells"

  # Model and controller UML class diagram generator
  gem 'railroady'
end

group :test do
  gem "faker", '~> 1.4'
  gem "capybara", '~> 2.4'
  gem "database_cleaner", '~> 1.4'
  gem "launchy", '~> 2.4'
  gem "selenium-webdriver", '>= 2.0'
end

gem 'bootstrap-sass', '~> 3.3'
gem 'autoprefixer-rails', '~> 6.0'
gem 'font-awesome-sass', '~> 4.3'

group :development do
  gem 'rails_layout'
end

gem 'pg', '~> 0.18'

# Loads environment variables from `.env` file.
gem 'dotenv-rails', '~> 2.0'

# Authentication
gem 'devise', '~> 3.4'

# Async devise mails
gem "devise-async", '>= 0.9'

# User roles
gem 'royce', '~> 1.0'

# Authorization
gem "pundit", '~> 1.0'

# For models with tree parent-child associations
gem 'acts_as_tree', '~> 2.1'

# Uploaders
gem 'carrierwave', '~> 0.10'

# Json support
gem 'json', '~> 1.8'

# Pagination
gem 'kaminari', '~> 0.16'

# Search engine gem on top of elasticsearch
gem 'searchkick', '~> 2.0', '>= 2.0.3'

# jQuery plugin for drop-in fix binded events problem caused by Turbolinks
gem 'jquery-turbolinks', '~> 2.1'

# Runs HTTP requests in parallel while cleanly encapsulating handling logic.
gem 'typhoeus', '~> 1.0'

# Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting, Rails related I18n stuff
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x

# A fast and very simple Ruby web server
# gem 'thin', '~> 1.6'

# A ruby web server built for concurrency
gem 'puma', '~> 3.4'

# Simple, efficient background processing for Ruby.
gem 'sidekiq', '< 5'

# Additional middleware for sidekiq.
gem 'sidekiq-middleware', '~> 0.3'

# Unicode algorithms for case conversion, normalization, text segmentation and more
gem 'unicode_utils', '>= 1.4'

# Complete geocoding solution for Ruby
gem 'geocoder', '~> 1.2'

# Sinatra DSL for quickly creating web applications is used by sidekiq monitoring page
gem 'sinatra', :require => nil

# Book metadata extraction library
gem 'bookshark', '~> 1.0.0.pre'

# A lightweight plugin that logs impressions per action or manually per model
gem 'impressionist', '= 1.5.1'

# A recommendation engine using Likes and Dislikes
gem 'recommendable', '~> 2.2'

# Bundler-like DSL and rake tasks for Bower on Rails
gem "bower-rails", '~> 0.11'

# A Gem to add Follow functionality for models
gem "acts_as_follower", '~> 0.2'

# Generate greeklish forms from Greek words
gem 'greeklish', '~> 0.0.1'

# The Swiss Army bulldozer of slugging and permalink plugins for ActiveRecord
gem 'friendly_id', '~> 5.1.0'

# A ruby library for working with Machine Readable Cataloging
gem 'marc', '~> 1.0.0'

# builds ActiveRecord named scopes that take advantage of PostgreSQL's full text search
gem 'pg_search', '~> 1.0.3'

# Making it easy to serialize models for client-side use
gem 'active_model_serializers', '~> 0.9.0'

# Simple gem that allows you to run multiple ActiveRecord::Relation using hash
gem 'active_hash_relation'

# Rack middleware for rate-limiting incoming HTTP requests configured to be used with Redis
gem 'redis-throttle', git: 'https://github.com/lelylan/redis-throttle.git'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible
gem 'rack-cors', :require => 'rack/cors'

# Allows for threaded comments to be added to multiple and different models.
gem 'acts_as_commentable_with_threading'

group :production, :staging do
  # Skylight is a smart profiler for Rails apps
  gem 'skylight', '~> 0.10.3'
end

group :development do
  # Performance management system
  gem 'newrelic_rpm', '~> 3.15', '>= 3.15.2.317'

  # Help to kill N+1 queries and unused eager loading.
  gem 'bullet', '~> 5.3'

  # Preview mail in the browser instead of sending.
  gem 'letter_opener', '~> 1.4', '>= 1.4.1'

  # Profiler for your development and production Ruby rack apps.
  gem 'rack-mini-profiler', '~> 0.10.1'
end

group :development do
  # CLI gem for comfortably working with icon fonts
  gem 'fontello_rails_converter', '~> 0.4.4'
end

# Adds typed hstore backed fields to an ActiveRecord model.
gem 'hstore_accessor', '~> 1.0', '>= 1.0.3'

# Easy activity tracking for models
gem 'public_activity', '~> 1.5'

# Makes rendering and caching a collection of template partials easier and faster
gem 'multi_fetch_fragments', '~> 0.0.17'

# A rich text editor for everyday writing
gem 'trix', '~> 0.9.10'

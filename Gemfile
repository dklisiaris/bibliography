source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '3.1.7'


# Bundle edge Rails rinstead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use mysql as the database for Active Record
# gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# gem 'mini_racer', platforms: :ruby

# modernizr.js lib
gem 'modernizr-rails', '~> 2.7'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 1.1', group: :doc
gem 'thor', '~> 1.5'

# High Performance Haml Implementation (Rails 6.1 compatible)
gem 'hamlit-rails', '~> 0.2.3'

# Cells allow you to encapsulate parts of your page into separate MVC components
gem 'cells', '4.0.0.beta3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.20', require: false
gem 'rexml', '~> 3.4'

gem "base64", "0.1.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 12.0', platforms: [:mri, :windows]

  gem 'rspec-rails', '~> 4.0'
  gem 'factory_bot_rails', '~> 5.2'

  gem 'better_errors', '~> 2.7'
  gem 'binding_of_caller', '~> 1.0'

  # gem 'pry-byebug', '~> 3.11'
  # gem 'pry-rails', '~> 0.3'
  # gem 'pry-stack_explorer', '~> 0.6'
  # gem 'pry-rescue', '~> 1.6'

  # gem "rspec-cells"

  # Model and controller UML class diagram generator
  gem 'railroady', '~> 1.5'
end

group :test do
  gem 'faker', '~> 1.7'
  gem 'capybara', '~> 2.15'
  gem 'database_cleaner', '~> 1.5'
  gem "launchy", '~> 2.4'
  gem 'selenium-webdriver', '~> 3.3'
end

gem 'bootstrap-sass', '~> 3.4'
gem 'autoprefixer-rails', '~> 6.0'
gem 'font-awesome-sass', '~> 4.7'

gem 'pg', '~> 1.5'

gem 'nokogiri', '~> 1.18'

# Loads environment variables from `.env` file.
gem 'dotenv-rails', '~> 2.0'

# Authentication
gem 'devise', '~> 4.7'

# Async devise mails
# gem 'devise-async', '~> 1.0'

# Facebook OAuth2 Strategy for OmniAuth
gem 'omniauth-facebook', '~> 7.0'

# A Google OAuth2 strategy for OmniAuth 1.x
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'certified', '~> 1.0'

# Authorization
gem 'pundit', '~> 1.0'

# For models with tree parent-child associations
gem 'acts_as_tree', '~> 2.1'

# Uploaders
gem 'carrierwave', '~> 1.0'
gem 'piet-binary', '~> 0.2.0'

# Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick
gem 'mini_magick', '~> 4.9'

# Json support
gem 'json', '~> 2.3'

# Pagination
gem 'kaminari', '~> 1.2'

# Search engine gem on top of elasticsearch
gem 'searchkick', '~> 4.5'

# Runs HTTP requests in parallel while cleanly encapsulating handling logic.
gem 'typhoeus', '~> 1.3'
# Faraday 2.x is incompatible with typhoeus adapter; pin Faraday to 1.x
gem 'faraday', '~> 1.10'
# FFI gem needs to be updated for Ruby 2.7.7 compatibility
gem 'ffi', '~> 1.15.0'

# A simple HTTP and REST client for Ruby
gem 'rest-client', '~> 2.0'

# Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting, Rails related I18n stuff
gem 'rails-i18n', '~> 6.0.0'

# A fast and very simple Ruby web server
# gem 'thin', '~> 1.6'

# A ruby web server built for concurrency
gem 'puma', '~> 4.3'

# Simple, efficient background processing for Ruby.
gem 'sidekiq', '~> 6.0'

# Additional middleware for sidekiq.
gem 'sidekiq-middleware', '~> 0.3'

# Unicode algorithms for case conversion, normalization, text segmentation and more
gem 'unicode_utils', '>= 1.4'

# HTML entity encoding/decoding
gem 'htmlentities'

# Complete geocoding solution for Ruby
gem 'geocoder', '~> 1.2'

# Sinatra DSL for quickly creating web applications is used by sidekiq monitoring page
gem 'sinatra', require: nil

# Book metadata extraction library
# gem 'bookshark', '~> 1.0'

# A lightweight plugin that logs impressions per action or manually per model
# gem 'impressionist', '~> 2.0'

# A recommendation engine using Likes and Dislikes
gem 'recommendable', '~> 2.2'

# Bundler-like DSL and rake tasks for Bower on Rails
gem 'bower-rails', '~> 0.11'

# A Gem to add Follow functionality for models
gem 'acts_as_follower', '~> 0.2'

# Generate greeklish forms from Greek words
gem 'greeklish', '~> 0.0.1'

# The Swiss Army bulldozer of slugging and permalink plugins for ActiveRecord
gem 'friendly_id', '~> 5.4.0'

# A ruby library for working with Machine Readable Cataloging
gem 'marc', '~> 1.0.0'

# Making it easy to serialize models for client-side use
gem 'active_model_serializers', '~> 0.9.0'

# Simple gem that allows you to run multiple ActiveRecord::Relation using hash
gem 'active_hash_relation'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible
gem 'rack-cors', '~> 1.0'

# Threaded comments are now implemented using a custom Commentable concern
# See app/models/concerns/commentable.rb and app/models/comment.rb
# gem 'acts_as_commentable_with_threading' # REMOVED - replaced with custom implementation

# group :production, :staging do
#   # Skylight is a smart profiler for Rails apps
#   gem 'skylight', '~> 1.3'
# end

group :development do
  # # Performance management system
  # gem 'newrelic_rpm', '~> 4.2'

  # Help to kill N+1 queries and unused eager loading.
  gem 'bullet', '~> 8.1'

  # Preview mail in the browser instead of sending.
  gem 'letter_opener', '~> 1.4', '>= 1.4.1'

  # Profiler for your development and production Ruby rack apps.
  gem 'rack-mini-profiler', '~> 4.0'

  # Deployment Automation
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger', '>= 0.2.1'

  # Remove the following if your app does not use Rails
  gem 'capistrano-rails'

  # Remove the following if your server does not use RVM
  gem 'capistrano-rvm'

  gem 'capistrano-sidekiq'
  gem 'capistrano-rails-console'
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-faster-assets'
  gem 'capistrano-bower', '~> 1.1'

  # Annotate Rails classes with schema and routes info
  gem 'annotate', '~> 3.0'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 4.4'
  gem 'spring-watcher-listen', '~> 2.1'
end

# Adds typed hstore backed fields to an ActiveRecord model.
gem 'hstore_accessor', '~> 1.0', '>= 1.0.3'

# Easy activity tracking for models
gem 'public_activity', '~> 1.5'

# Makes rendering and caching a collection of template partials easier and faster
# gem 'multi_fetch_fragments', '~> 0.0.17'

# A rich text editor for everyday writing
gem 'trix-rails', '~> 2.2', require: 'trix'

# The fastest JSON parser and object serializer.
gem 'oj', '~> 3.1'

# Stopwords filter or use some based on Snowball stopwords lists
gem 'stopwords-filter', '~> 0.4.1', require: 'stopwords'

# Search Engine Optimization (SEO) plugin for Ruby on Rails applications.
gem 'meta-tags', '~> 2.4'

# SitemapGenerator is the easiest way to generate Sitemaps in Ruby.
gem 'sitemap_generator', '~> 6.1'

# A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface.
gem 'redis', '~> 5.0'
gem 'redis-namespace', '~> 1.11'
# gem 'redis-rails', '~> 5.0'
# Web-based Redis browser
gem 'redis-browser', '~> 0.5.1'

# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', '~> 0.9.7'

# Exception and uptime monitoring
gem 'honeybadger', '~> 4.7'

# SaaS based Application protection and monitoring platform
# gem 'sqreen', '~> 1.20'

# Interactor provides a common interface for performing complex user interactions.
gem 'interactor', '~> 3.0'

# RuboCop is a Ruby code style checking and code formatting tool.
gem 'rubocop', '~> 1.3', require: false
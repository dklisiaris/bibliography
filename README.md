# Bibliography - Book Catalog App

[![Dependency Status](https://gemnasium.com/dklisiaris/bibliography.svg)](https://gemnasium.com/dklisiaris/bibliography)

---------------------------------------------------------------------------------------------------

  NOTICE: This project is __under development__ and not funtional yet.
  
---------------------------------------------------------------------------------------------------

## Description
Bibliography is a catalog for books and authors of Greek national bibliography which provides a public API to 3rd party book services. 
On top of that, libraries or individual users can create collections of their books and users can see where they can loan the book they want.
Some social features are available too.

|      | Url         |
|------|:------------|
| home | https://github.com/dklisiaris/bibliography |
| bugs | https://github.com/dklisiaris/bibliography/issues |
| docs | http://www.rubydoc.info/github/dklisiaris/bibliography/master |

## Installation
This section's target is to help setup the app and get it running locally.

__Software requirements__

- [Postgres 9.1+ with contrib-packages](http://www.postgresql.org/download/), on Ubuntu check this quick setup [guide](https://gist.github.com/dklisiaris/3c1cd76c28ab86c8ee9c)
- [Redis 2.6+](http://redis.io/download), on Ubuntu check Digital Ocean's [guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis)
- [Elasticsearch 1.4.4+](https://www.elastic.co/downloads/elasticsearch) (Optional)
- [Ruby 2.0+](http://www.ruby-lang.org/en/downloads/) (we recommend 2.0.0-p353 or higher)
- [node](http://nodejs.org) ([on github](https://github.com/joyent/node))
- [bower](https://github.com/bower/bower) (>= 0.10.0) installed with npm

Clone repository 
```
git clone https://github.com/dklisiaris/bibliography.git
```

Install depedencies
```ruby
# Go to the root of the app
cd bibliography

# Install ruby gems
bundle install

# Install javascript libraries
rake bower:install
```



All sensitive information is stored in environment variables. 
We use dotenv gem to manage these vars.
Create a file named `.env` in the root folder and export environment variables as seen below:

```ruby
# Database credentials in development
export DEVELOPMENT_DATABASE_USERNAME=db_username
export DEVELOPMENT_DATABASE_PASSWORD=db_password

# Database credentials in production
export PRODUCTION_DATABASE_USERNAME=db_username
export PRODUCTION_DATABASE_PASSWORD=db_password
export PRODUCTION_DATABASE_HOST=db_host
export PRODUCTION_DATABASE_PORT=db_port

# Elasticsearch host (Usually localhost or some password protected remote url)
export ELASTICSEARCH_URL=http://username:password@host/

# Redis hosts (Usually the same, default is redis://localhost:6379/0)
export REDIS_SERVER_URL=redis://redis.example.com:7372/12
export REDIS_CLIENT_URL=redis://redis.example.com:7372/12

# Mail credentials (we use sendgrid for transactional mails)
export SENDGRID_USERNAME=username
export SENDGRID_PASSWORD=key_provided_by_sendgrid

# Devise secret key (Use rake secret to generate it)
export DEVISE_SECRET_KEY=key_generated_with_rake_secret_command

# Base secret key (Use rake secret to generate it)
export SECRET_KEY_BASE=key_generated_with_rake_secret_command
```

Create and migrate database
```ruby
bundle exec rake db:create
bundle exec rake db:migrate
```

Start rails server (thin) from the root directory of your Rails app
```
rails s
```

Start sidekiq from the root directory of your Rails app
```
bundle exec sidekiq -C config/sidekiq.yml
```

## API Docs

The API documentation is a [slate](https://github.com/tripit/slate) app in `doc/api`. 

Do what ever changes you want in api docs and rebuild them by running:
```ruby
# Go to the slate folder
cd doc/api

# Install ruby gems
bundle install

# Build them
bundle exec middleman build
```

The new docs will be available in `public/docs/api` folder.
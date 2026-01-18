# config valid only for current version of Capistrano
# lock "3.9.0"

set :application, "bibliography"
set :repo_url, ENV["BIBLIOGRAPHY_CAP_REPOSITORY"]
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Settings for capistrano-db-tasks
require 'capistrano-db-tasks'

set :disallow_pushing, true
set :assets_dir, %w(public/uploads)
set :local_assets_dir, %w(public/uploads)
set :db_local_clean, false

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w[publickey],
  keys: %w[~/.ssh/id_rsa],
  encryption: %w[
    chacha20-poly1305@openssh.com
    aes256-ctr aes192-ctr aes128-ctr
    aes256-gcm@openssh.com aes128-gcm@openssh.com
  ],
  kex: %w[diffie-hellman-group14-sha256 ecdh-sha2-nistp256],
  hmac: %w[hmac-sha2-256 hmac-sha2-512]
}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/bibliography
# set :deploy_to, "/var/www/bibliography"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rvm_ruby_version, '3.1.7'

# Capistrano-sidekiq 3.0.0 configuration for Sidekiq 6+
# Sidekiq 6 removed daemonization, so capistrano-sidekiq handles it differently
# These settings ensure compatibility
# NOTE: We're using systemd to manage Sidekiq, so we disable Capistrano hooks
# and manually restart via systemctl during deployment
set :sidekiq_default_hooks, false
set :sidekiq_roles, :app

# Custom task to restart Sidekiq via systemd after deployment
namespace :sidekiq do
  desc 'Restart Sidekiq via systemd'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, 'bibliography-sidekiq'
    end
  end
end

# Hook into deployment to restart Sidekiq after publishing
after 'deploy:publishing', 'sidekiq:restart'

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'bower:install CI=true'
        end
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'


namespace :deploy do
  desc 'Refresh Sitemaps'
  task :refresh_sitemap do
    on roles(:web) do
      within release_path do
        execute :rake, "sitemap:refresh RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end
end

namespace :deploy do
  desc 'Create Sitemaps'
  task :create_sitemap do
    on roles(:web) do
      within release_path do
        execute :rake, "sitemap:create RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end
end

# after 'deploy:publishing', 'deploy:refresh_sitemap'

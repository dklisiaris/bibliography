# frozen_string_literal: true

namespace :credentials do
  desc "Import config/secrets.yml into config/credentials/<env>.yml.enc (pass ENV=development or ENV=test)"
  task import_from_secrets: :environment do
    env = ENV.fetch("CREDENTIALS_ENV", Rails.env)
    secrets_path = Rails.root.join("config/secrets.yml")

    unless secrets_path.exist?
      abort "config/secrets.yml not found. Copy your local secrets file before importing."
    end

    raw = YAML.safe_load(ERB.new(secrets_path.read).result, aliases: true)
    section = raw.fetch(env) do
      abort "No '#{env}' section in config/secrets.yml"
    end

    content = build_credentials_yaml(section)
    write_encrypted_credentials(env, content)

    puts "Wrote config/credentials/#{env}.yml.enc"
    puts "Wrote config/credentials/#{env}.key (gitignored — store securely for your team)"
    puts "Edit with: EDITOR=\"vim\" bin/rails credentials:edit --environment #{env}"
  end

  def build_credentials_yaml(section)
    section = section.stringify_keys
    tree = {
      "secret_key_base" => section["secret_key_base"],
      "facebook" => compact_hash(
        "app_id" => section["FACEBOOK_APP_ID"],
        "app_secret" => section["FACEBOOK_APP_SECRET"],
        "access_token" => section["FACEBOOK_ACCESS_TOKEN"]
      ),
      "google" => compact_hash(
        "client_id" => section["GOOGLE_CLIENT_ID"],
        "client_secret" => section["GOOGLE_CLIENT_SECRET"]
      ),
      "mailjet" => compact_hash(
        "username" => section["MAILJET_USERNAME"],
        "password" => section["MAILJET_PASSWORD"]
      ),
      "honeybadger" => compact_hash("api_key" => section["HONEYBADGER_API_KEY"]),
      "sqreen" => compact_hash("token" => section["SQREEN_TOKEN"]),
      "skylight" => compact_hash("token" => section["SKYLIGHT_TOKEN"])
    }

    tree.compact_blank.to_yaml
  end

  def compact_hash(**pairs)
    pairs.compact_blank.presence
  end

  def write_encrypted_credentials(env, content)
    credentials_dir = Rails.root.join("config/credentials")
    FileUtils.mkdir_p(credentials_dir)

    key_path = credentials_dir.join("#{env}.key")
    enc_path = credentials_dir.join("#{env}.yml.enc")

    key = key_path.exist? ? key_path.read.strip : ActiveSupport::EncryptedConfiguration.generate_key
    File.write(key_path, key)

    encrypted = ActiveSupport::EncryptedConfiguration.new(
      config_path: enc_path,
      key_path: key_path,
      env_key: "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    )
    encrypted.write(content)
  end
end

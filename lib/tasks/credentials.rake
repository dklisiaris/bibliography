# frozen_string_literal: true

namespace :credentials do
  desc "Import secrets YAML into config/credentials/<env>.yml.enc (CREDENTIALS_ENV=production SECRET_KEY_BASE=...)"
  task import_from_secrets: :environment do
    env = ENV.fetch("CREDENTIALS_ENV", Rails.env)
    secrets_path = Pathname.new(ENV.fetch("SECRETS_YAML_PATH", Rails.root.join("config/secrets.yml")))

    unless secrets_path.exist?
      abort "#{secrets_path} not found. Download VPS shared/config/secrets.yml or set SECRETS_YAML_PATH."
    end

    raw = YAML.safe_load(ERB.new(secrets_path.read).result, aliases: true)
    section = raw.fetch(env) do
      abort "No '#{env}' section in #{secrets_path}"
    end

    content = build_credentials_yaml(section)
    write_encrypted_credentials(env, content)

    puts "Wrote config/credentials/#{env}.yml.enc"
    puts "Wrote config/credentials/#{env}.key (gitignored — upload to server with cap credentials:upload_key)"
    puts "Verify with: CREDENTIALS_ENV=#{env} bin/rails credentials:verify"
    puts "Edit with: EDITOR=\"vim\" bin/rails credentials:edit --environment #{env}"
  end

  desc "Check that required secrets are present for CREDENTIALS_ENV (default: current Rails.env)"
  task verify: :environment do
    env = ENV.fetch("CREDENTIALS_ENV", Rails.env)
    secrets = Bibliography::Secrets.for_environment(env)
    required = %i[
      secret_key_base
      FACEBOOK_APP_ID
      FACEBOOK_APP_SECRET
      GOOGLE_CLIENT_ID
      GOOGLE_CLIENT_SECRET
      MAILJET_USERNAME
      MAILJET_PASSWORD
      HONEYBADGER_API_KEY
    ]
    optional = %i[SKYLIGHT_TOKEN SQREEN_TOKEN FACEBOOK_ACCESS_TOKEN]

    missing = required.reject { |key| secrets[key].present? }
    absent_optional = optional.reject { |key| secrets[key].present? }

    if missing.any?
      abort "Missing required secrets for #{env}: #{missing.join(', ')}"
    end

    puts "OK: #{env} has all #{required.size} required secrets."
    puts "Optional not set: #{absent_optional.join(', ')}" if absent_optional.any?
  end

  def build_credentials_yaml(section)
    section = section.stringify_keys
    secret_key_base = section["secret_key_base"].presence || ENV["SECRET_KEY_BASE"]
    if secret_key_base.blank?
      abort "secret_key_base is blank. Export SECRET_KEY_BASE from the server before importing production/staging."
    end

    tree = {
      "secret_key_base" => secret_key_base,
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

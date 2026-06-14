# frozen_string_literal: true

module Bibliography
  # Unified secret access during migration from secrets.yml to Rails credentials.
  # Reads encrypted credentials first; falls back to config/secrets.yml when needed.
  # Uses direct file reads so secret_key_base works during application.rb boot.
  module Secrets
    class << self
      def secret_key_base
        secrets.secret_key_base
      end

      def secrets
        @secrets = nil if reload?
        @secrets ||= build_secrets(Rails.env)
      end

      def for_environment(env)
        build_secrets(env.to_s)
      end

      private

      def reload?
        defined?(Rails) && Rails.application && !Rails.application.config.cache_classes
      rescue StandardError
        false
      end

      def build_secrets(env)
        ActiveSupport::OrderedOptions.new.tap do |options|
          from_credentials = credential_values(env)
          from_secrets_yml = secrets_yml_values(env)

          all_keys(from_credentials, from_secrets_yml).each do |key|
            value = from_credentials[key].presence || from_secrets_yml[key]
            options[key] = value if value.present?
          end
        end
      end

      def all_keys(*hashes)
        hashes.flat_map(&:keys).uniq
      end

      def credential_values(env)
        tree = credential_tree(env)
        return {} if tree.blank?

        {
          secret_key_base: tree[:secret_key_base],
          FACEBOOK_APP_ID: dig(tree, :facebook, :app_id),
          FACEBOOK_APP_SECRET: dig(tree, :facebook, :app_secret),
          FACEBOOK_ACCESS_TOKEN: dig(tree, :facebook, :access_token),
          GOOGLE_CLIENT_ID: dig(tree, :google, :client_id),
          GOOGLE_CLIENT_SECRET: dig(tree, :google, :client_secret),
          MAILJET_USERNAME: dig(tree, :mailjet, :username),
          MAILJET_PASSWORD: dig(tree, :mailjet, :password),
          HONEYBADGER_API_KEY: dig(tree, :honeybadger, :api_key),
          SQREEN_TOKEN: dig(tree, :sqreen, :token),
          SKYLIGHT_TOKEN: dig(tree, :skylight, :token)
        }.compact
      rescue ActiveSupport::EncryptedFile::MissingKeyError, ActiveSupport::MessageEncryptor::InvalidMessage
        {}
      end

      def credential_tree(env)
        return {} unless credentials_available?(env)

        content = encrypted_credentials(env).read
        return {} if content.blank?

        YAML.safe_load(content, aliases: true).with_indifferent_access
      end

      def encrypted_credentials(env)
        ActiveSupport::EncryptedConfiguration.new(
          config_path: encrypted_path(env),
          key_path: key_path(env),
          env_key: "RAILS_MASTER_KEY",
          raise_if_missing_key: true
        )
      end

      def secrets_yml_values(env)
        section = secrets_yml_section(env)
        return {} if section.blank?

        section.symbolize_keys
      rescue Errno::ENOENT, RuntimeError
        {}
      end

      def secrets_yml_section(env)
        return {} unless secrets_yml_path.exist?

        raw = YAML.safe_load(ERB.new(secrets_yml_path.read).result, aliases: true)
        raw[env] || raw[env.to_s] || {}
      end

      def credentials_available?(env)
        encrypted_path(env).exist? && key_path(env).exist?
      end

      def encrypted_path(env)
        Rails.root.join("config/credentials/#{env}.yml.enc")
      end

      def key_path(env)
        Rails.root.join("config/credentials/#{env}.key")
      end

      def secrets_yml_path
        Rails.root.join("config/secrets.yml")
      end

      def dig(hash, *keys)
        keys.reduce(hash) { |h, key| h.is_a?(Hash) ? h[key] : nil }
      end
    end
  end
end

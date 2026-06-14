# frozen_string_literal: true

namespace :credentials do
  desc "Upload config/credentials/<stage>.key from your machine to the server shared path"
  task :upload_key do
    stage = fetch(:stage)
    local_key = Pathname.new("config/credentials/#{stage}.key")

    unless local_key.exist?
      abort "Missing #{local_key}. Generate it first with credentials:import_from_secrets."
    end

    on roles(:app) do
      remote_dir = shared_path.join("config/credentials")
      execute :mkdir, "-p", remote_dir
      upload! local_key.to_s, remote_dir.join("#{stage}.key").to_s
    end

    puts "Uploaded #{local_key} → shared/config/credentials/#{stage}.key"
  end
end

# frozen_string_literal: true

class StorageImportJob < MaintenanceJob
  def perform
    Dir.glob("#{Rails.root}/tmp/storage/**/*.json").each do |file|
      data_hash = JSON.parse(File.read(file))
      ImportJob.perform_later(data_hash)
    end
  end
end

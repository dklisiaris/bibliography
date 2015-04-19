class StorageImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform
    Dir.glob("#{Rails.root}/tmp/storage/**/*.json").each do |file|
      data_hash = JSON.parse(File.read(file))
      ImportWorker.perform_async(data_hash)
    end 
  end

end
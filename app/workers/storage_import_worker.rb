class StorageImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform
    # Dir.glob("#{Rails.root}/tmp/storage/**/*.json").each do |file|
    #   data_hash = JSON.parse(File.read(file))
    #   ImportWorker.perform_async(data_hash)
    # end
    files_to_import = []
    for i in 81..100 do
      files_to_import << Dir.glob("#{Rails.root}/tmp/storage/json_book_pages/#{i.to_s}/*.json")
    end
    files_to_import.flatten!

    files_to_import.each do |file|
      data_hash = JSON.parse(File.read(file))
      ImportWorker.perform_async(data_hash)
    end  
  end

end
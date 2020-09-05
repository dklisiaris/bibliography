# frozen_string-literal: true

class RefreshBookAuthorsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: 5

  def perform(book_id)
    @book_record = Book.find(book_id)
    response = Bookshark::Extractor.new(format: 'json').book(id: @book_record.biblionet_id)
    response_hash = JSON.parse(response)
    book_hash = response_hash['book'].first
    authors_hash = book_hash['author']
    contributors_hash = book_hash['contributors']

    refresh_authors(authors_hash)
    refresh_contributors(contributors_hash)
  end

  private

  def refresh_authors(authors_hash)
    return unless authors_hash.present?

    authors_hash.each do |author|
      if author['b_id'].blank? && author == "Συλλογικό έργο"
        @book_record.update(collective_work: true)
        next
      end

      author_record =
        if Author.exists?(biblionet_id: author['b_id'])
          Author.find_by(biblionet_id: author['b_id'])
        else
          names = author['name'].split(',')
          Author.create(biblionet_id: author['b_id'],
                        firstname: names.count > 1 ? names[1].strip : '',
                        lastname: names[0].strip)
        end

      if @book_record.writers.none? { |w| w.biblionet_id == author_record.biblionet_id }
        @book_record.contributions.create(job: 0, author: author_record)
      end
    end
  end

  def refresh_contributors(contributors_hash)
    return unless contributors_hash.present?

    contributors_hash.each do |job, contributors|
      job_index = Contribution.jobs[job]
      contributors.each do |contributor|
        contributor_record =
          if Author.exists?(biblionet_id: contributor['b_id'])
            Author.find_by(biblionet_id: contributor['b_id'])
          else
            names = contributor['name'].split(',')
            Author.create(biblionet_id: contributor['b_id'],
                          firstname: names.count > 1 ? names[1].strip : '',
                          lastname: names[0].strip)
          end

        if @book_record.contributors.none? { |w| w.biblionet_id == contributor_record.biblionet_id }
          @book_record.contributions.create(job: job_index, author: contributor_record)
        end
      end
    end
  end

end
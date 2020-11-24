# frozen_string_literal: true

module Biblionet
  # :nodoc
  class FetchBook
    include Interactor

    def call
      @biblionet_book_id = context.biblionet_book_id

      book_hash = request_get_title
      context.fail!(error: 'Book does not exist') if book_hash.is_a?(String)

      book_hash = book_hash&.flatten&.first
      context.fail!(error: 'Book does not have title') if book_hash['Title'].blank?

      b_publisher_id = book_hash['PublisherID']

      contributor_hashes = request_get_contributors.flatten
      contributor_ids = contributor_hashes.map { |s| s['ContributorID'] }
      contributor_ids.each do |id|
        next if Author.where(biblionet_id: id).exists?

        create_author(id)
      end

      company_hashes = request_get_companies.flatten
      company_ids = company_hashes.map { |s| s['CompanyID'] }
      company_ids.each do |id|
        next if Publisher.where(biblionet_id: id).exists?

        create_publisher(id)
      end

      subject_hashes = request_get_subjects.flatten
      subject_ids = subject_hashes.map { |s| s['SubjectsID'] }
      subject_ids.each do |id|
        next if id.nil? || Category.where(biblionet_id: id).exists?

        create_category(id)
      end

      genre_id =
        if book_hash['CategoryID'].present? && Genre.where(biblionet_id: book_hash['CategoryID']).exists?
          Genre.find_by(biblionet_id: book_hash['CategoryID']).id
        elsif book_hash['CategoryID'].present?
          Genre.create(name: book_hash['Category'], biblionet_id: book_hash['CategoryID']).id
        end

      publisher_id = Publisher.find_by(biblionet_id: b_publisher_id).id
      new_book = init_book(book_hash, publisher_id, genre_id)

      categories = Category.where(biblionet_id: subject_ids)
      new_book.categories = categories

      new_book.contributions.each(&:destroy) if new_book.contributions.any?
      contributor_hashes.each do |h|
        author_id = Author.find_by(biblionet_id: h['ContributorID']).id
        new_book.contributions.build(job: Author.jobs[h['ContributorType']], author_id: author_id)
      end
      new_book.save!
    end

    private

    def init_book(book_hash, publisher_id, genre_id)
      image = "https://biblionet.gr#{book_hash['CoverImage']}"
      publication_year = Date.parse(book_hash['CurrentPublishDate']).year if book_hash['CurrentPublishDate'].present?
      isbn = book_hash['ISBN'].presence

      book = Book.find_or_initialize_by(isbn: isbn)
      book.attributes = {
        title: book_hash['Title'],
        subtitle: book_hash['Subtitle'],
        image: image,
        isbn: isbn,
        isbn13: book_hash['ISBN_2'].presence,
        issn: book_hash['ISBN_3'].presence,
        ismn: book_hash['ISMN'].presence,
        series_name: book_hash['Series'],
        series_volume: book_hash['SeriesNo'],
        publication_year: publication_year,
        publication_version: book_hash['EditionNo'],
        publication_place: book_hash['Place'],
        first_publish_date: book_hash['FuturePublishDate'].presence,
        current_publish_date: book_hash['CurrentPublishDate'].presence,
        future_publish_date: book_hash['FuturePublishDate'].presence,
        price: book_hash['Price'],
        price_updated_at: book_hash['LastUpdate'],
        size: book_hash['Dimensions'],
        pages: book_hash['PageNo'],
        cover_type: (book_hash['Cover'].present? ? ::Book.cover_types[book_hash['Cover']] : nil),
        availability: (book_hash['Availability'].present? ? ::Book.availabilities[book_hash['Availability']] : nil),
        format: (book_hash['TitleType'].present? ? ::Book.formats[book_hash['TitleType']] : nil),
        original_language: (book_hash['LanguageOriginal'].present? ? ::Book::LANGUAGES.index(book_hash['LanguageOriginal']) : nil),
        original_title: book_hash['OriginalTitle'],
        publisher_id: publisher_id,
        genre_id: genre_id,
        description: book_hash['Summary'],
        biblionet_id: book_hash['TitlesID']
      }
      book
    end

    def create_publisher(company_id)
      company_hash = request_get_company(company_id).flatten.first
      Publisher.create(
        name: company_hash['Title'],
        alternative_name: company_hash['AlternativeTitle'],
        address: company_hash['Address'],
        telephone: company_hash['TelephoneNumner'],
        email: company_hash['Email'],
        website: company_hash['Website'],
        biblionet_id: company_hash['ComID']
      )
    end

    def create_category(subject_id)
      subject_hash = request_get_subject(subject_id).flatten.first
      parent_id =
        if subject_hash['SubjectParent'].nil?
          nil
        elsif Category.where(biblionet_id: subject_hash['SubjectParent']).exists?
          Category.find_by(biblionet_id: subject_hash['SubjectParent']).id
        else
          create_category(subject_hash['SubjectParent']).id
        end

      Category.create(
        name: subject_hash['SubjectTitle'],
        ddc: subject_hash['SubjectDDC'],
        biblionet_id: subject_hash['SubjectsID'],
        parent_id: parent_id
      )
    end

    def create_author(person_id)
      contributor_hash = request_get_person(person_id).flatten.first
      extra_info = "#{contributor_hash['BornYear']}-#{contributor_hash['DeathYear']}"
      image = "https://biblionet.gr#{contributor_hash['Photo']}"
      Author.create(
        firstname: contributor_hash['Name'],
        lastname: contributor_hash['Surname'],
        middle_name: contributor_hash['MiddleName'],
        born_year: contributor_hash['BornYear'],
        death_year: contributor_hash['DeathYear'],
        extra_info: extra_info,
        image: image,
        biography: contributor_hash['Biography'],
        biblionet_id: contributor_hash['PersonsID']
      )
    end

    def request_get_title
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_title')
    end

    def request_get_contributors
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_contributors')
    end

    def request_get_companies
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_title_companies')
    end

    def request_get_subjects
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_title_subject')
    end

    def request_get_person(person_id)
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_person', person: person_id)
    end

    def request_get_company(company_id)
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_company', company: company_id)
    end

    def request_get_subject(subject_id)
      make_request('https://biblionet.diadrasis.net/wp-json/biblionetwebservice/get_subject', subject: subject_id)
    end

    def make_request(url, payload = { title: @biblionet_book_id })
      res = RestClient::Request.execute(
        method: :post,
        url: url,
        payload: {
          username: 'testuser',
          password: 'testpsw'
        }.merge(payload)
      )
      JSON.parse(res.body)
    end
  end
end

# frozen_string_literal: true

module Biblionet
  # BiblioNet API is decommissioned — kept as attribute-mapping reference for Phase 10.
  #
  # Original orchestration (API calls removed):
  #   get_title → validate Title/ISBN → get_contributors → get_companies → get_subjects
  #   → create missing authors/publishers/categories → init_book → assign categories/contributions
  #
  # :nodoc
  class FetchBook
    include Interactor

    def call
      context.fail!(error: 'Biblionet API disabled until Phase 10 book metadata pipeline')
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
      company_hash = nil # BiblioNet get_company response removed
      return unless company_hash

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
      subject_hash = nil # BiblioNet get_subject response removed
      return unless subject_hash

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
      contributor_hash = nil # BiblioNet get_person response removed
      return unless contributor_hash

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
  end
end

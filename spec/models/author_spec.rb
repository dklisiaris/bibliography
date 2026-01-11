require 'rails_helper'

RSpec.describe Author, :type => :model do
  it 'is valid with lastname only' do
    author = build(:author)
    expect(author).to be_valid
  end

  it 'is invalid without lastname' do
    author = build(:author, lastname: nil)
    author.valid?

    expect(author.errors[:lastname]).to be_present
    expect(author.errors[:lastname].first).to match(/κενό|blank/i)
  end  
end

# == Schema Information
#
# Table name: authors
#
#  id                  :integer          not null, primary key
#  firstname           :string
#  lastname            :string
#  extra_info          :string
#  biography           :text
#  image               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  biblionet_id        :integer
#  impressions_count   :integer          default(0)
#  slug                :string
#  tsearch_vector      :tsvector
#  contributions_count :integer          default(0)
#  uploaded_avatar     :string
#  masterpiece_id      :integer
#  middle_name         :string
#  born_year           :integer
#  death_year          :integer
#
# Indexes
#
#  authors_tsearch_idx              (tsearch_vector) USING gin
#  index_authors_on_biblionet_id    (biblionet_id) UNIQUE
#  index_authors_on_masterpiece_id  (masterpiece_id)
#  index_authors_on_slug            (slug) UNIQUE
#

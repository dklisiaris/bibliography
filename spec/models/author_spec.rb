require 'rails_helper'

RSpec.describe Author, :type => :model do
  it 'is valid with lastname only' do
    author = build(:author)
    expect(author).to be_valid
  end

  it 'is invalid without lastname' do
    author = build(:author, lastname: nil)
    author.valid?
    expect(author.errors[:lastname]).to include("can't be blank")
  end  
end

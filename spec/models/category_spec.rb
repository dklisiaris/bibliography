require 'rails_helper'

RSpec.describe Category, :type => :model do
  it "is valid with name and ddc" do
    category = build(:category)
    expect(category).to be_valid
  end

  it "is invalid without name" do 
    category = build(:category, name: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it "is invalid without ddc" do 
    category = build(:category, ddc: nil)
    category.valid?
    expect(category.errors[:ddc]).to include("can't be blank")
  end

  it "has a unique set of name and ddc" do    
    cat_name = Faker::Lorem.sentence
    category = create(:category, name: cat_name, ddc: "800") 
    category_duplicate = build(:category, name: cat_name, ddc: "800")

    category_duplicate.valid?
    expect(category_duplicate.errors[:name]).to include("This category already exists")
  end

  it "is valid with no parent" do
    category = build(:category, parent_id: nil)
    expect(category).to be_valid
  end

  it "is valid with a parent which exists" do
    parent = create(:category) 
    child  = build(:category, parent_id: parent.id) 
      
    child.valid?
    expect(child).to be_valid       
  end  

  it "is invalid with a parent which doesn't exist" do
    category = build(:category, parent_id: 999999)  
      
    category.valid?
    expect(category.errors[:parent_id]).to include("Parent doesn't exist.")        
  end

end

# == Schema Information
#
# Table name: categories
#
#  id                :integer          not null, primary key
#  name              :string
#  ddc               :string
#  slug              :string
#  biblionet_id      :integer
#  parent_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  impressions_count :integer          default(0)
#  featured          :boolean          default(FALSE)
#  tsearch_vector    :tsvector
#
# Indexes
#
#  categories_tsearch_idx         (tsearch_vector) USING gin
#  index_categories_on_parent_id  (parent_id)
#  index_categories_on_slug       (slug) UNIQUE
#

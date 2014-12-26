require 'rails_helper'

RSpec.describe Category, :type => :model do
  it "is valid with name and ddc" do
    category = Category.new(
      name: "Some book genre",
      ddc: "356.03")
    expect(category).to be_valid
  end

  it "is invalid without name" do 
    category = Category.new(name: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it "is invalid without ddc" do 
    category = Category.new(ddc: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it "has a unique set of name and ddc" do
    category = Category.create(
      name: "Some book genre",
      ddc: "356.03") 
    category_duplicate = Category.new(
      name: "Some book genre",
      ddc: "356.03")

    category_duplicate.valid?
    expect(category_duplicate.errors[:name]).to include("This category already exists")
  end

  it "is valid with no parent" do
    category = Category.new(
      name: "Some book genre",
      ddc: "356.03",
      parent_id: nil)
    expect(category).to be_valid
  end

  it "is invalid with a parent which doesn't exist" do
    category = Category.new(
      name: "Some book genre",
      ddc: "356.03",
      parent_id: 999999)  
      
    category.valid?
    expect(category.errors[:parent_id]).to include("Parent doesn't exist.")        
  end

end

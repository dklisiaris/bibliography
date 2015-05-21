class Publisher < ActiveRecord::Base
  has_many :places, as: :placeable
  has_many :books

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  searchkick batch_size: 50, 
  callbacks: :async, 
  word_start: ['name'],
  # text_middle: [:owner],
  # word_start: [:name, :owner],
  autocomplete: ['name']

  def search_data
    {
      name: name,
      owner: owner
    }
  end  
end

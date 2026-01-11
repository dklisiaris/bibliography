namespace :view_tracking do
  desc "Recalculate impressions_count for all resources"
  task recalculate_counts: :environment do
    puts "Recalculating impressions_count for Books..."
    Book.find_each do |book|
      count = Impression.where(impressionable_type: 'Book', impressionable_id: book.id).count
      book.update_column(:impressions_count, count)
    end

    puts "Recalculating impressions_count for Authors..."
    Author.find_each do |author|
      count = Impression.where(impressionable_type: 'Author', impressionable_id: author.id).count
      author.update_column(:impressions_count, count)
    end

    puts "Recalculating impressions_count for Publishers..."
    Publisher.find_each do |publisher|
      count = Impression.where(impressionable_type: 'Publisher', impressionable_id: publisher.id).count
      publisher.update_column(:impressions_count, count)
    end

    puts "Recalculating impressions_count for Categories..."
    Category.find_each do |category|
      count = Impression.where(impressionable_type: 'Category', impressionable_id: category.id).count
      category.update_column(:impressions_count, count)
    end

    puts "Done!"
  end

  desc "Clean old impressions (older than 1 year)"
  task clean_old: :environment do
    cutoff_date = 5.years.ago
    count = Impression.where("created_at < ?", cutoff_date).count
    puts "Deleting #{count} old impressions..."
    Impression.where("created_at < ?", cutoff_date).delete_all
    puts "Done!"
  end
end
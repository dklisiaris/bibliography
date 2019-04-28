namespace :ratings do
  desc "Restore redis ratings from the db backup"

  task restore: :environment do
    puts 'Starting ratings restore...'

    Rating.all.each do |r|
      rater    = r.user
      rateable = r.rateable

      case r.rate
      when "like"
        rater.like(rateable)
      when "dislike"
        rater.dislike(rateable)
      when "hide"
        rater.hide(rateable)
      else
        puts "invalid rate"
      end

      if r.bookmark?
        rater.bookmark(rateable)
      end

    end

    puts 'Ratings restore completed.'
  end
end

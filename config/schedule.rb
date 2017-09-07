# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.day, at: '01:00 am' do
  desc 'Pick and set a new daily suggestion'
  runner "DailySuggestion.set_book_of_the_day"
end

every 1.day, at: '06:00 am' do
  desc 'Fetch and import new books'
  runner "ContentUpdateWorker.perform_async(500)"
end

# Learn more: http://github.com/javan/whenever

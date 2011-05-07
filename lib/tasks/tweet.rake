namespace :tweet do
  desc "Tweet the most popular vurl of the day"
  task daily: :environment do
    Vurl.tweet_most_popular_of_the_day
  end
end

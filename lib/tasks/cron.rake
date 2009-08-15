task :cron => :environment do
  Vurl.tweet_most_popular_of_the_day
end

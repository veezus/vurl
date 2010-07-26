namespace :user do
  desc "Assign api tokens to users that don't have them"
  task :generate_api_tokens => :environment do
    users = User.all(:conditions => {:api_token => nil})
    puts "Processing #{users.count} users... "
    count = 0
    users.each do |user|
      count += 1
      user.generate_api_token
      user.save(false)
      if count % 1000 == 0
        print '.'
        STDOUT.flush
      end
    end
  end
end

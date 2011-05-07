namespace :user do
  desc "Assign api tokens to users that don't have them"
  task generate_api_tokens: :environment do
    users = User.all(conditions: {api_token: nil}, limit: 1000)
    while users.any? do
      count = 0
      users.each do |user|
        count += 1
        user.generate_api_token
        user.save(false)
      end
      print '.'
      STDOUT.flush
      users = User.all(conditions: {api_token: nil}, limit: 1000)
    end
  end
end

Fabricator(:user) do
  name 'Anonymous'
  email {|u| "#{u.new_hash}@example.com"}
  password 'password'
end

Fabricator(:claimed_user, from: :user) do
  after_create do |user|
    user.claim({password: 'password'})
  end
end

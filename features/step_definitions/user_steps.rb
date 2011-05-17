Given "I am signed in as an admin" do
  steps %Q{
    Given the following user:
      | email    | admin@example.com |
      | password | password          |
      | admin    | true              |
    And I am on the home page
    And I follow "log in as another user"
    And I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Log in"
  }
end

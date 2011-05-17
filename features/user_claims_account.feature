Feature: User claims account

  Scenario: success
    Given I am on the home page
    When I follow "claim this account"
    And I fill in "Name" with "New User"
    And I fill in "Email" with "new_user@example.com"
    And I fill in "New password" with "password"
    And I fill in "Website" with "http://example.com"
    And I fill in "Blog" with "http://blog.example.com"
    And I press "Save changes"
    Then I should be on the edit user page
    And I should see "Successfully saved your changes"
    And the "Name" field should contain "New User"
    And the "Email" field should contain "new_user@example.com"
    And the "New password" field should be blank
    And the "Website" field should contain "http://example.com"
    And the "Blog" field should contain "http://blog.example.com"

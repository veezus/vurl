Feature: Admin flags vurl as spam

  Scenario: success
    Given the following vurl:
      | url   | http://google.com |
      | title | Google!           |
    And that vurl has 1 click
    And I am signed in as an admin
    And I am on the home page
    When I follow "Flag as spam"
    Then I should be on the home page
    And I should see "Successfully flagged vurl as spam"
    And I should not see "Google!"

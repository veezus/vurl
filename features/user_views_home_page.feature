Feature: User views home page

  Scenario: no spam vurls in the most popular list
    Given the following vurl:
      | title  | Cheap Viagra!   |
      | status | flagged_as_spam |
    And that vurl has 2 clicks
    And the following vurl:
      | title | This is relevant to your interests |
    And that vurl has 1 click
    When I go to the home page
    Then I should see "This is relevant to your interests"
    And I should not see "Cheap Viagra!"

  Scenario: cannot flag as spam
    When I go to the home page
    Then I should not see "Flag as spam"

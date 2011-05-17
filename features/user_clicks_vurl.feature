Feature: User clicks vurl

  Scenario: when flagged as spam
    Given the following vurl:
      | status | flagged_as_spam |
    When I go to that vurl's redirect page
    Then I should see "Flagged as spam"

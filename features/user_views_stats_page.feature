Feature: User views stats page

  Scenario: when flagged as spam
    Given the following vurl:
      | url    | http://google.com |
      | title  | Google!           |
      | status | flagged_as_spam   |
    When I go to that vurl's stats page
    Then I should see "Your vurl has been flagged as spam by the system"
    And I should see "Share your vurl"

Feature: User clicks vurl

  Scenario: when flagged as spam
    Given the following vurl:
      | url    | http://example.com |
      | title  | Example Web Page   |
      | status | flagged_as_spam    |
    When I go to that vurl's redirect page
    Then I should see "Flagged as spam"
    And I should see "Original URL: http://example.com"

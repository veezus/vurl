Feature: User views twitter feed

  @javascript
  Scenario: success
    Given the Twitter API returns search results
    When I go to the home page
    Then I should see the following tweet: "Most popular vurl today? Ruby on Rails: Ecosystem http://vurl.me/BJCX"

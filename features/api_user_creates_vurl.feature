Feature: API user creates vurl

  Background:
    Given the following user:
      | api_token | woot_api |

  Scenario: success with JSON
    When that user submits a JSON API request to shorten "http://veez.us"
    Then the vurl was created and associated with that user

  Scenario: success without JSON
    When that user submits a non-JSON API request to shorten "http://blog.veez.us"
    Then the vurl was created and associated with that user

Feature: User creates vurl

  Background:
    Given I am on the home page

  Scenario: success
    When I fill in "URL" with "http://google.com"
    And I press "Vurlify!"
    Then I should see "Share your vurl"
    And I should see "http://google.com"
    And I should see "By Anonymous"
    And I should see "0 total clicks"

  Scenario: invalid url
    When I fill in "URL" with "http://vurl.me/tramadol"
    And I press "Vurlify!"
    Then I should be on the vurls page
    And I should see "Url shouldn't point back to vurl.me"
    And I should see "Url shouldn't reference TRAMADOL"
    And the "URL" field should contain "http://vurl.me/tramadol"

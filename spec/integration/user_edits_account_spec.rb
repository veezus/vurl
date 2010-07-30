require 'spec_helper'

Feature "User edits account" do
  Given "I'm viewing the home page as a logged in user" do
    let(:user) { Fabricate(:user) }
    executes do
      page.cleanup!
      login_as user
    end
    When "I visit the edit page" do
      executes { click_link 'My Account' }
      Then "I should see my information" do
        page.should have_css("input#user_email[type=text]", :value => user.email)
      end
    end
  end
end

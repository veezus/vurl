require 'spec_helper'

Feature "User claims account" do
  Given "an unclaimed account" do
    When "I visit the home page" do
      executes { visit root_path }
      Then "I should see an option to claim my account" do
        page.should have_css("a[href='#{edit_user_path(User.last)}']", "claim this account")
      end
    end
  end
end

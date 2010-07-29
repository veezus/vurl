require 'spec_helper'

Feature "User claims account" do
  Given "an unclaimed account" do
    When "I visit the home page" do
      executes { visit root_path }
      Then "I should see an option to claim my account" do
        page.should have_css("a[href='#{edit_user_path(User.last)}']", "claim this account")
      end
      When "I follow the link to claim my account" do
        executes { click_link "claim this account" }
        Then "I should see a form with email, password, website, and blog options" do
          page.should have_css("input#user_email[type=text]")
          page.should have_css("input#user_password[type=password]")
          page.should have_css("input#user_website[type=text]")
          page.should have_css("input#user_blog[type=text]")
        end
        When "I fill in all fields and submit the form" do
          executes do
            fill_in "Email", :with => 'veez@example.com'
            fill_in "New password", :with => '1234'
            fill_in "Website address", :with => 'http://veez.us'
            fill_in "Blog address", :with => 'http://blog.veez.us'
            click_button 'Save changes'
          end
          Then "I should be on the edit page" do
            page.current_url.should == edit_user_url(User.last)
          end
          And "I should see a success message" do
            page.should have_content("Successfully saved your changes")
          end
          And "I should see my values updated" do
            page.should have_css("input#user_email[type=text]", 'veez@example.com')
            page.should have_css("input#user_website[type=text]", 'some spam nonsense')
            page.should have_css("input#user_blog[type=text]", 'an offer to buy viagra')
          end
        end
      end
    end
  end
end

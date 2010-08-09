require 'spec_helper'

Feature "User logs in" do
  Given "I'm a user with a previous account and I've cleared my cookies" do
    let(:user) { Fabricate(:user) }
    executes do
      User.destroy_all
      user
    end
    When "I go to the home page" do
      executes { visit root_path }
      Then "I should see an option to log in as a different user" do
        page.should have_css("a[href='#{new_user_session_path}']", :text => 'log in as another user')
      end
      When "I login as a different user" do
        executes do
          click_link "log in as another user"
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => 'password'
          click_button 'Log in'
        end
        Then "I should see a success message" do
          page.should have_content("Successfully logged in")
        end
        When "I follow My Account" do
          executes { click_link "My Account" }
          Then "I should see my correct details" do
            page.should have_css("input#user_email[type=text]", user.email)
          end
        end
      end
    end
  end
end

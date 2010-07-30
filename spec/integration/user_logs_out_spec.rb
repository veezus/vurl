require 'spec_helper'

Feature "User logs out" do
  Given "I'm a user logged in with a claimed account" do
    let(:my) { Fabricate(:claimed_user) }
    let(:dave) { Fabricate(:claimed_user) }
    executes do
      login_as dave
    end
    When "I visit the home page" do
      executes { visit root_path }
      Then "I should see the currently logged in user name" do
        page.should have_content(dave.email)
      end
      And "I should see a 'not you?' link" do
        page.should have_css("a[href='#{new_user_session_path}']", :text => "not you?")
      end
      When "I click 'not you?'" do
        executes { click_link "not you?" }
        Then "I should be on the log in page" do
          current_path.should == new_user_session_path
        end
        When "I submit valid credentials" do
          executes do
            fill_in 'Email', :with => my.email
            fill_in 'Password', :with => my.password
            click_button 'Log in'
          end
          Then "I should be on the home page" do
            current_path.should == root_path
          end
          And "I should see a success message" do
            page.should have_content("Successfully logged in")
          end
          And "I should see my email address displayed" do
            page.should have_content(my.email)
          end
        end
      end
    end
  end
end

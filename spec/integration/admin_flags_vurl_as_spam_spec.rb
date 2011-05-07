require 'spec_helper'

Feature "Admin flags vurl as spam" do
  Given "a vurl exists" do
    let(:vurl) { Fabricate(:vurl, title: "My Spammy Vurl") }
    let(:click) { Fabricate(:click, vurl: vurl) }
    executes { click }
    Given "I'm viewing the home page as an admin" do
      let(:admin) { Fabricate(:user, admin: true) }
      executes do
        login_as admin
        visit root_path
      end
      When "I follow 'Flag as spam'" do
        executes { click_link("Flag as spam") }
        Then "I should be on the home page" do
          current_url.should == root_url
        end
      end
    end
  end
end

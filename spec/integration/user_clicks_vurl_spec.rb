require 'spec_helper'

Feature "User clicks vurl" do
  Given "an existing vurl" do
    let(:vurl) { Fabricate(:vurl, :url => 'http://example.com') }
    executes { vurl }
    When "that vurl has been flagged as spam" do
      executes { vurl.flag_as_spam! }
      When "I follow the vurl" do
        executes { visit redirect_path(:slug => vurl.slug) }
        Then "I should be on the spam page" do
          current_url.should == spam_url(:slug => vurl.slug)
        end
        And "I should see a spam notice" do
          page.should have_content("spam and/or malware")
        end
        And "I should see a link to the original URL" do
          page.find(:css, "a[href='http://example.com']").text.should == "http://example.com"
        end
      end
    end
  end
end

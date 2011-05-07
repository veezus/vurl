require 'spec_helper'

Feature "User creates vurl" do
  Given "a valid url" do
    When "I submit it" do
      executes { submit_vurl 'http://veez.us' }
      Then "a vurl is created" do
        Vurl.last.url.should == 'http://veez.us'
      end
      And "I am redirected to the vurl stats page" do
        current_path.should == stats_path(Vurl.last.slug)
      end
    end
  end

  Given "an invalid url" do
    When "I submit it" do
      executes { submit_vurl 'whatthe?' }
      Then "it re-renders the new vurl page" do
        current_path.should == vurls_path
      end
      And "an error message is displayed" do
        page.should have_content("Url is invalid")
      end
    end
  end

  Given "a very long url" do
    When "I submit it" do
      executes { submit_vurl('http://veez.us/?q=1234567890123456789012345678901234567890') }
      Then "it should be truncated for me" do
        page.should have_content("http://veez.us/?q=12345678901234567890123456789...")
      end
      When "a very long title is found" do
        let(:vurl) { Vurl.last }
        executes do
          vurl.update_attribute(:title, "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
          visit stats_path(vurl.slug)
        end
        Then "it should display the full title" do
          page.should have_css("a", text: vurl.title)
        end
      end
    end
  end
end

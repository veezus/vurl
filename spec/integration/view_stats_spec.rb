require 'spec_helper'

describe "View stats" do
  let(:vurl) { Fabricate(:vurl) }
  let(:user) { vurl.user }

  it "displays the new vurl" do
    visit stats_path(vurl.slug)
    page.should have_css("a[href='#{redirect_url(vurl.slug)}']", text: redirect_url(vurl.slug))
  end

  it "displays the date the vurl was created" do
    page.should have_content("less than a minute ago")
  end

  context "when the user has profile information" do
    executes do
      user.update_attributes(name: 'My Name', blog: 'http://blog.oinopa.com', website: 'http://oinopa.com')
      visit stats_path(vurl.slug)
    end
    it "displays the user's blog" do
      page.should have_css("a[href='http://blog.oinopa.com']")
    end
    it "displays the user's name" do
      page.should have_content(user.name)
    end
    it "displays the user's website" do
      page.should have_css("a[href='http://oinopa.com']")
    end
  end

  context "when the user has no name" do
    it "displays 'Anonymous'" do
      visit stats_path(vurl.slug)
      page.should have_content("By Anonymous")
    end
  end

  context "when the user has a blog but no website" do
    it "is grammatically correct" do
      user.update_attribute(:blog, 'http://blog.oinopa.com')
      visit stats_path(vurl.slug)
      page.should have_content("(blog)")
    end
  end

  context "when the user has no blog but does have a website" do
    it "is grammatically correct" do
      user.update_attribute(:website, 'http://oinopa.com')
      visit stats_path(vurl.slug)
      page.should have_content("(website)")
    end
  end

  context "when the user has no blog and no website" do
    it "doesn't reference either" do
      visit stats_path(vurl.slug)
      page.should_not have_content("blog")
      page.should_not have_content("website")
    end
  end

  context "when the vurl has been marked as spam" do
    before { vurl.flag_as_spam }
    it "includes a notice" do
      visit stats_path(vurl.slug)
      page.should have_css("#spam_warning", text: /flagged as spam/)
    end
  end

  context "when the vurl is not spam" do
    it "doesn't include a spam notice" do
      visit stats_path(vurl.slug)
      page.should_not have_css("#spam_warning", text: /flagged as spam/)
    end
  end

  context "with clicks more than an hour old" do
    before do
      3.times { Fabricate(:click, vurl: vurl) }
      vurl.clicks.last.update_attribute(:created_at, 2.hours.ago)
      visit stats_path(vurl.slug)
    end
    it "displays the number of clicks within the last hour" do
      page.should_not have_content("3 in the last hour")
      page.should have_content("2 in the last hour")
    end
    it "displays the total number of clicks" do
      page.should have_content("3 total clicks")
    end
  end
end

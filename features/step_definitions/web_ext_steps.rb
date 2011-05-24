Given "the Twitter API returns search results" do
  FakeWeb.register_uri :get, /twitter\.com/,
    :body => File.read(Rails.root.join("spec", "data", "twitter_vurlme_search_results.json"))
end

Then /^the "([^"]+)" field should be blank$/ do |field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should be_nil
end

Then /^I should see the following tweet: "([^"]+)"$/ do |content|
  within("#vurlme_tweets .tweet") do
    page.should have_content content
  end
end

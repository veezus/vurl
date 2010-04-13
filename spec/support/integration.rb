class ActiveSupport::TestCase
  def current_path
    URI.parse(current_url).path
  end
end

Spec::Matchers.define :contain_text do |text|
  match do |response_body|
    response_text = Webrat.nokogiri_document(response_body).text.squish
    response_text.include?(text)
  end
end

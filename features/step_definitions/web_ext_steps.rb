Then /^the "([^"]+)" field should be blank$/ do |field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should be_nil
end

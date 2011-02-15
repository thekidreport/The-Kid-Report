Given /^the following applications:$/ do |applications|
  Application.create!(applications.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) application$/ do |pos|
  visit applications_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following applications:$/ do |expected_applications_table|
  expected_applications_table.diff!(tableish('table tr', 'td,th'))
end

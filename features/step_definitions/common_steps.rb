When(/^I click "(.*?)"$/) do |element|
  click_on element
end

When(/^I click '(.*?)'$/) do |element|
  click_on element
end

When(/^I confirm$/) do

end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content text[0]
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should_not have_content text[0]
end

Then(/^I should see validation message$/) do
  page.should have_content 'Please review the problems below'
end

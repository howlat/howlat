Given(/^I am on (.*?)$/) do |page|
  visit path_to(page)
end

When(/^I go to (.*?)$/) do |page|
  visit path_to(page)
end

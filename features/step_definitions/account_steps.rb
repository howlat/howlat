When(/^I click "Overview" in the left menu$/) do
  click_on "Overview"
end

When(/^I click "Delete your user account" button$/) do
  click_on "Delete your user account"
end

When(/^Confirm that I want to delete my account$/) do

end

Then(/^I should have my account deleted$/) do
  User.where(id: @user.id).first.should be_nil
end

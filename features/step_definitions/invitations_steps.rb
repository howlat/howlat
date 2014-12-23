Given(/^I select room$/) do
  FactoryGirl.create(:organization, @organization)
  FactoryGirl.create(:room, @room)
  Member.create user_id: 1, organization_id: 1, role_id: Role.owner.id
  visit '/organizations/1/rooms'
end

When(/^I enter correct email$/) do
  fill_in "invite[email]", with: "user1@example.com"
  click_on "Send"
end

Then(/^Invitation will be send to this email$/) do
  sleep 3
  page.should have_content 'user1@example.com'
end

Given(/^i select my organization$/) do
  #add a member
  @user ||= User.create email: "user2@example.com", password: '12235W', accepted: true
  #add to organization
  @member = Member.create user_id: @user.id, organization_id: 1, role_id: Role.member.id

  visit '/organizations/1'
end

When(/^I change member status to 'Admin'$/) do
  click_on 'Set as admin'
end

Then(/^I should see this member with 'Admin' status$/) do
  page.should have_content 'Set as member'
end

When(/^I click "(.*?)" on members list$/) do |arg1|
  click_on arg1
end

Then(/^I should see only the owner of the organization$/) do
  sleep 3
  page.should_not have_content 'user2@example.com'
end

When(/^I change set member status to "(.*?)"$/) do |arg1|
  click_on '(set)',  :match => :first
  fill_in 'title', with: arg1, :match => :first
  click_on 'Set', :match => :first
end

Then(/^I should see this member with "(.*?)" title$/) do |arg1|
  sleep 3
  page.should have_content 'Manager'
end

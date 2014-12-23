# Given(/^I click 'create room'$/) do
#   FactoryGirl.create(:organization, @organization)
#   Member.create user_id: 1, organization_id: 1, role_id: Role.owner.id
#   visit '/organizations/1/rooms'
#   click_on 'Create room'
# end

Given(/^I have room "(.*?)" under organization "(.*?)" created$/) do |room_name, org_name|
  @organization = FactoryGirl.create(:organization, {
    name: org_name,
    user_id: @user.id
    })
  @member = FactoryGirl.create(:member, {
    user_id: @user.id,
    organization_id: @organization.id,
    role_id: Role.owner.id
    })
  @room = FactoryGirl.create(:room, {
    organization_id: @organization.id,
    name: room_name
    })
  @invitation = FactoryGirl.create(:invitation, {
    user_id: @user.id,
    accepted: true,
    room_id: @room.id
    })
end


When(/^I select room "(.*?)" under organization "(.*?)" from menu$/) do |room_name, org_name|
  pending
end

When(/^I enter correct room data$/) do
  fill_in 'room[name]', with: 'My room'
  find("input[type='submit']").click
end

When(/^I enter incorrect room data$/) do
  fill_in 'room[name]', with: ''
  find("input[type='submit']").click
end


Given(/^select room list$/) do
  FactoryGirl.create(:organization, @organization)
  Member.create user_id: 1, organization_id: 1, role_id: Role.owner.id
  FactoryGirl.create(:room, @room)
  visit '/organizations/1/rooms'
end


Given(/^i select room$/) do
  click_on 'Edit'
end

When(/^I change correctly room data$/) do
  fill_in 'room[name]', with: 'My room 2'
  find("input[type='submit']").click
end

When(/^I change incorrectly room data$/) do
  fill_in 'room[name]', with: ''
  find("input[type='submit']").click
end


Then(/^I should see message about successfull delete$/) do
 page.should have_content 'deleted'
end

Then(/^I should be redirected to this room$/) do
  page.find("#room-menu li.active").should have_content 'My room'
end

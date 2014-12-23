Given(/^I own organization named "(.*?)"$/) do |org_name|
  @organization = FactoryGirl.create(:organization, name: org_name, user_id: @user.id)
  @member = FactoryGirl.create(:member, user_id: @user_id, role_id: Role.owner.id, organization_id: @organization.id)
end

Given(/^Organization named "(.*?)" already exists$/) do |org_name|
  @organization = FactoryGirl.create(:organization, name: org_name, user_id: @user.id)
  @member = FactoryGirl.create(:member, user_id: @user_id, role_id: Role.owner.id, organization_id: @organization.id)
end

When(/^I enter "(.*?)" as the name of the organization$/) do |org_name|
  find("input[name='organization[name]']").click
  fill_in 'organization[name]', with: org_name
  find(".new_organization input[type='submit'], .edit_organization input[type='submit']").click
end

Then(/^I should see message about successfull creation$/) do
  page.should have_content 'created'
end

When(/^I click on Edit near organization named "(.*?)"$/) do |org_name|
  visit(path_to("organization named #{org_name} edit page"))
end


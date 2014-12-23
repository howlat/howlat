### UTILITY METHODS ###

def create_visitor
  @visitor ||= {
    id: 1,
    name: "Tommy McTesty",
    email: "tomasz.jasiulek@thesoftwarehouse.pl",
    password: "12345678",
    accepted: true
  }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit logout_url
end

def populate_users
  FactoryGirl.create(:user, @visitor)
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_up
  visit signup_path
  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  # fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_in
  visit login_url
  fill_in "session_email", :with => @visitor[:email]
  fill_in "session_password", :with => @visitor[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  click_link 'Logout' unless first(:xpath, '//a[@href="logout"]').nil?
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  click_link 'Logout'
end

When /^I sign up with valid user data$/ do
  create_visitor
  delete_user
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  delete_user
  sign_up
end

# When /^I sign up without a password confirmation$/ do
#   create_visitor
#   @visitor = @visitor.merge(:password_confirmation => "")
#   sign_up
# end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  delete_user
  sign_up
end

# When /^I sign up with a mismatched password confirmation$/ do
#   create_visitor
#   @visitor = @visitor.merge(:password_confirmation => "changeme123")
#   sign_up
# end

When /^I return to the site$/ do
  visit root_url
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit account"
  fill_in "user_name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When(/^I sign up without an email$/) do
  create_visitor
  @visitor = @visitor.merge(email: "")
  delete_user
  sign_up
end

When(/^I sign up with an already taken email$/) do
  create_visitor
  populate_users
  @visitor = @visitor.merge(email: User.first.email)
  sign_up
end

### THEN ###
Then /^I should be signed in$/ do
  page.first(:xpath, "//a[@href='#{login_path}']").should_not be
  page.first(:xpath, "//a[@href='#{signup_path}']").should_not be
  page.first(:xpath, "//a[@href='#{logout_path}']").should be
end

Then /^I should be signed out$/ do
  page.first(:xpath, "//a[@href='#{login_path}']").should be
  page.first(:xpath, "//a[@href='#{signup_path}']").should be
  page.first(:xpath, "//a[@href='#{logout_path}']").should_not be
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.first(:xpath, '//input[@id="user_email"]/..').should have_content "is invalid"
end

Then /^I should see a missing password message$/ do
  page.first(:xpath, "//input[@id='user_password']/..").should have_content "can't be blank"
end

# Then /^I should see a missing password confirmation message$/ do
#   page.first(:xpath, "//input[@id='user_password_confirmation']/..").should have_content "doesn't match Password"
# end

Then /^I should see a mismatched password message$/ do
  page.first(:xpath, "//input[@id='user_password_confirmation']/..").should have_content "doesn't match Password"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Email address or password was incorrect. Please, try again."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end

Then(/^I should see a missing email message$/) do
  page.first(:xpath, "//input[@id='user_email']/..").should have_content "can't be blank"
end

Then(/^I should see a message that email has been already taken$/) do
  page.first(:xpath, "//input[@id='user_email']/..").should have_content "taken"
end

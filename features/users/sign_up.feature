Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up

    Background:
      Given I am not logged in

    Scenario: User signs up with valid data
      When I sign up with valid user data
      Then I should be signed in

    Scenario: User signs up with invalid email
      When I sign up with an invalid email
      Then I should see an invalid email message

    Scenario: User signs up without email
      When I sign up without an email
      Then I should see a missing email message

    Scenario: User signs up with email that has been already taken
      When I sign up with an already taken email
      Then I should see a message that email has been already taken

    Scenario: User signs up without password
      When I sign up without a password
      Then I should see a missing password message

    # Scenario: User signs up without password confirmation
    #   When I sign up without a password confirmation
    #   Then I should see a missing password confirmation message

    # Scenario: User signs up with mismatched password and confirmation
    #   When I sign up with a mismatched password confirmation
    #   Then I should see a mismatched password message

Feature: Delete Account
  As a registered user
  I want to delete my user account

    @culerity
    Scenario: I sign in and delete my account
      Given I am logged in
      When I click "Overview" in the left menu
      And I click "Delete your user account" button
      And Confirm that I want to delete my account
      Then I should be signed out
      And I should have my account deleted


Feature: Edit room
  As a registered user of the website
  I want to edit existing room

    Scenario: I sign in and edit room correctly
      Given I am logged in
      And I have room "Room 1" under organization "TSH" created
      When I go to organization named "TSH"
      And I change correctly room data
      Then I should see "My room 2"

    Scenario: I sign in and edit room incorectly
      Given I am logged in
      And I have room "Room 1" under organization "TSH" created
      When I go to organization named "TSH"
      When I select room "Room 1" under organization "TSH" from menu
      And I change incorrectly room data
      Then I should see validation message

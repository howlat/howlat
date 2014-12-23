Feature: Create invitation to room
  As a registered user of the website with a organization
  I want to invite a someone to a room

    @culerity
    Scenario: I sign in and create invitation
      Given I am logged in
      And I select room 
      When I click "Invite users"
      And I enter correct email 
      Then Invitation will be send to this email
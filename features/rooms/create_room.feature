Feature: Create room
  As a registered user of the website with a organization
  I want to add a new room

    Scenario: I sign in and create room
      Given I am logged in
      And I have organization "TSH" created
      And I click 'Create room'
      When I enter correct room data
      Then I should be redirected to this room

    Scenario: I sign in and create room
      Given I am logged in
      And I have organization "TSH" created
      When I go to
      When I click 'Create room'
      And I enter incorrect room data
      Then I should see validation message

Feature: Delete room
  As a registered user of the website
  I want to delete existing room

  	@culerity
    Scenario: I sign in and want to delete room
      Given I am logged in
      And I am on the rooms page
      When I click 'Delete'
      And I confirm
      Then I should see message about successfull delete

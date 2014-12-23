Feature: Remove member
  As a registered user of the website
  I want to change status of a member in my organization

  	@culerity
    Scenario: I sign in, select organization and change member status to 'Admin'
	  Given I am logged in
      And select organization list
      And i select my organization
      When I click "Remove" on members list
      Then I should see only the owner of the organization

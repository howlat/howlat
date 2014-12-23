Feature: Set member title
  As a registered user of the website
  I want to set title of a member in my organization

  	@culerity
    Scenario: I sign in, select organization and change member status to 'Admin'
	  Given I am logged in
      And select organization list
      And i select my organization
      When I change set member status to "Manager"
      Then I should see this member with "Manager" title

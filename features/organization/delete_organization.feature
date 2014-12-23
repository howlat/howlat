Feature: Delete organization
  As a registered user of the website
  I want to delete existing organization

  	@culerity
    Scenario: I sign in and edit my account
      Given I am logged in
      And select organization list
      When I click 'delete'
      And I confirm 
      Then I should not see 'My organization' on the list
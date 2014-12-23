Feature: Create organization
  As a registered user of the website
  I want to add a new organization

    Scenario: I sign in and create organization
      Given I am logged in
      And I am on the organizations page
      When I enter "TSH" as the name of the organization
      Then I should see message about successfull creation

    Scenario: I sign in and create organization with blank name
      Given I am logged in
      And I am on the organizations page
      When I click "Create organization"
      And I enter "" as the name of the organization
      Then I should see validation message

    Scenario: I sign in and want to create organization that already exists
      Given I am logged in
      And I am on the organizations page
      And Organization named "TSH" already exists
      When I click "Create organization"
      And I enter "TSH" as the name of the organization
      Then I should see validation message

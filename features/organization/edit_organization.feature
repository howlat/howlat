Feature: Edit organization
  As a registered user of the website
  I want to edit existing organization

    Scenario: I sign in and want to change my organization's name
      Given I am logged in
      And I own organization named "TSH"
      When I go to the organizations page
      And I click on Edit near organization named "TSH"
      And I enter "TSH 2" as the name of the organization
      Then I should see "TSH 2"

    Scenario: I sign in and want to set my organization's name blank
      Given I am logged in
      And I own organization named "TSH"
      When I go to the organizations page
      And I click on Edit near organization named "TSH"
      And I enter "" as the name of the organization
      Then I should see validation message

@account_create @basic @smoke @regression
Feature: Account Clean -  Suite TearDown
  As a tester
  I want to disassociate phone numbers
  From any new created account
Scenario: Disassociate phone number from created accounts
  Given I set the staging environment if enabled
  Given I login into Admin page
  And I go to Accounts view
  And I search for account for last created user
  And I go to associated Phone Numbers view
  And I disassociate all phone numbers
  And I clean the list of created accounts
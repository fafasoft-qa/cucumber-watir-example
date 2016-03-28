@account_create @basic @smoke @regression
Feature: Account_Creation
  As an admin
  I want to create a new account
  #Background: Add numbers to the pool before create an account
  #  Given I set the staging environment if enabled
    #Given I add two "Toll" and "US" phone numbers to the pool

  Scenario:  Add a new account
    Given I set the staging environment if enabled
    Given I login into Admin page
    Then I go to Account form for the default reseller and client
    And I add a new account for the default Client

  Scenario: Login and create event with the new account
    Given I am at the Login Page
    And I sign into cinchcast with just created account
    And I should be on homepage
    And I removed any event access restriction if exists
    And I removed all upcoming shows
    And I set up a basic event without registration required to go live now
    When I click save
    Then I am in the studio
    And I delete the event
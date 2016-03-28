@load_reg
Feature: Guest Registration
  As a user
  I want to register for a show
  So that I can view the permalink as a registered guest

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  #And I removed any event access restriction if exists
  #And I removed all upcoming shows
Scenario: Load test on registration api
    And I set up a basic event with registration required to go live now
    And I set a custom registration description
    And I click save
    And I am in the studio
    And I go to Event Info tab
    And I send 1 valid registration from the registration api


@regression @smoke @api @dev
Feature: Guest Registration API
  As a user
  I want to register for a show
  So that I can view the permalink as a registered guest with API

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed any event access restriction if exists
  And I removed all upcoming shows

Scenario: Register as a guest with an email address in preshow without custom registration description
  And I set up a basic event with registration required to go live now
  And I click save
  And I am in the studio
  And I go to Event Info tab
  And I send a valid registration from the registration api
  And I go to the permalink from api email
  And I am on the permalink page
  Then I see event description on Permalink Page



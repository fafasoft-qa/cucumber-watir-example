@regression @smoke @dev
Feature: Event Access Page
  As a user
  I want to change event access settings
  So that I can filter certain domains on registration page

  Background:
  Given I set the staging environment if enabled
    Given I am at the Login Page
    And I sign into cinchcast
    And I removed any event access restriction if exists
    And I should be on homepage
    And I removed all upcoming shows

Scenario: Validate blacklist setting
  And I go to Event Access page
  And I should be on Event Access page
  And I remove all added domains
  And I set "gmail.com" for "blacklist" and save
  And I should be on homepage
  And I set up a basic event with registration required to go live now
  And I add a Presenter with Dial-In
  And I set adjust pre event environment on '0' minutes
  And I click save
  And I am in the studio
  And I go to Event Info tab
  And I click the permalink
  And I am on Guest Registration Page
  And I enter my email address as "GuestAMS@gmail.com"
  And I Submit Registration
  And I see message warning about domain is not allowed
  And I enter my email address as "GuestAMS@yahoo.com"
  And I Submit Registration
  Then I have succesfully registered for the upcoming event

  Scenario: Validate whitelist setting
    And I go to Event Access page
    And I should be on Event Access page
    And I remove all added domains
    And I set "gmail.com" for "whitelist" and save
    And I should be on homepage
    And I set up a basic event with registration required to go live now
    And I add a Presenter with Dial-In
    And I set adjust pre event environment on '0' minutes
    And I click save
    And I am in the studio
    And I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    When I enter my email address as "GuestAMS@yahoo.com"
    And I Submit Registration
    And I see message warning about domain is not allowed
    And I enter my email address as "GuestAMS@gmail.com"
    And I Submit Registration
    Then I have succesfully registered for the upcoming event
    And  I go to home page
    And I should be on homepage
    And I go to Event Access page
    And I should be on Event Access page
    And I remove all added domains
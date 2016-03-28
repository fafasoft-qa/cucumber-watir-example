@regression @dev
Feature: Create Page
  As a user
  I want to fill out the create page
  So that I go into studio

  Background:
  Given I set the staging environment if enabled
    Given I am at the Login Page
    And I sign into cinchcast
    And I should be on homepage
    And I removed any event access restriction if exists
    And I removed all upcoming shows
    And I set up a basic event without registration required to go live now

Scenario: Create show with default settings
  When I click save
  Then I am in the studio
   And I delete the event
  
Scenario: Create show with startup audio
  When I upload startup audio
  When I click save
  Then I am in the studio
  And I delete the event

Scenario: Create show with Presenter
  When I add a Presenter with Dial-In
  And I click save
  Then I am in the studio
  And I delete the event

Scenario: Create show with Preview Image
  When I upload a preview image
  And I click save
  Then I am in the studio
  And I delete the event

Scenario: Create show with Presenter and Preview Image
  When I add a Presenter with Dial-In
  And I upload a preview image
  And I click save
  Then I am in the studio
  And I delete the event

Scenario: Create show with Presenter and Guest Registration turned on
  When I add a Presenter with Dial-In
  And I click save
  Then I am in the studio
  And I delete the event
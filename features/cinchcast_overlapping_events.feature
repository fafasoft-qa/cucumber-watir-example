@regression @smoke @basic @telephony @dev
Feature: Overlapping Events
  As a user
  I want to create concurrent events
  So that I can calling and going live for both overlapping events

  Background:
  Given I set the staging environment if enabled
    Given I am at the Login Page
    And I sign into cinchcast
    And I should be on homepage
    And I removed any event access restriction if exists
    And I removed all upcoming shows

  Scenario Outline: Verify going live and telephony for two overlapping events without registration required
    And I set up a basic event without registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    And I click save
    And I am in the studio
    And I call in as host
    And I wait '10' seconds
    And I see host in switchboard
    And I call in as Presenter to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I see presenter in switchboard
    And I call in as Guest to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I wait '30' seconds
    And I verify caller count in studio
    And I go Live
    And Go back to Home page to create an overlapping live event
    And I set up a basic event without registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    And I click save
    And I am in the studio
    And I call in as host
    And I wait '10' seconds
    And I see host in switchboard
    And I call in as Presenter to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I see presenter in switchboard
    And I call in as Guest to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I wait '30' seconds
    And I verify caller count in studio
    And I go Live
    And I go to Home page
    And I should be on homepage
    And I removed all upcoming shows

  Examples:
    | toll_free | country |
    | Toll | US      |

  Scenario Outline: Verify going live and telephony for two overlapping events with registration required
    And I set up a basic event with registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    And I set adjust pre event environment on '0' minutes
    And I click save
    And I am in the studio
    And I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    And I enter guest email address
    And I Submit Registration
    And I have succesfully registered for the upcoming event
    And I call in as host
    And I wait '30' seconds
    And I see host in switchboard
    And I call in as Registered Guest to "<toll_free>" and "<country>" phone number
    Then I wait '20' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I call in as Presenter to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I see presenter in switchboard
    And I wait '30' seconds
    And I verify caller count in studio
    And I go Live
    And Go back to Home page to create an overlapping live event
    And I set up a basic event with registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    And I set adjust pre event environment on '0' minutes
    And I click save
    And I am in the studio
    And I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    And I enter guest email address
    And I Submit Registration
    And I have succesfully registered for the upcoming event
    And I call in as host
    And I wait '30' seconds
    And I see host in switchboard
    And I call in as Registered Guest to "<toll_free>" and "<country>" phone number
    Then I wait '20' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I call in as Presenter to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I see presenter in switchboard
    And I wait '30' seconds
    And I verify caller count in studio
    And I go Live
    And I go to Home page
    And I should be on homepage
    And I removed all upcoming shows

  Examples:
    | toll_free | country |
    | Toll | US      |
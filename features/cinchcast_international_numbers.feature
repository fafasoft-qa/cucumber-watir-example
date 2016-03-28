@int_numbers @telephony
Feature: International phone numbers
  As a new user
  I want to add international phone numbers
  So that I can create an event to go live and call to them

  Scenario Outline:  Adding, using, and Removing Guest and Presenter international numbers
    Given I set the staging environment if enabled
    Given I add two "<toll_free>" and "<country>" phone numbers to the pool
    Given I login into Admin page
    And I go to Accounts view
    And I search for account for current user
    And I go to associated Phone Numbers view
    And I associate a new "<toll_free>" and "<country>" phone number for "presenter"
    And I associate a new "<toll_free>" and "<country>" phone number for "guest"
    Given I am at the Login Page
    And I should be on homepage
    And I removed all upcoming shows
    And I set up a basic event without registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    And I click save
    And I am in the studio
    And I call in as host
    And I wait '10' seconds
    And I see host in switchboard
    And I call in as Presenter to added phone number for "<country>"
    And I wait '30' seconds
    And I see presenter in switchboard
    And I call in as Guest to added phone number for "<country>"
    And I wait '30' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I verify caller count in studio
    And I go Live
    And I end the event
    Then I click on confirm to end the event
    And I go to Admin page
    And I go to Accounts view
    And I search for account for current user
    And I go to associated Phone Numbers view
    And I disassociate both added "<country>" phone numbers
#   Then I delete a number from the pool

  Examples:
    | toll_free | country |
    | Toll | US |


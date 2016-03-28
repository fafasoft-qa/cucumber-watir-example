@regression @smoke @dev
Feature: Edit Page
  As a user
  I want to be able to go to an event
  So that I can edit previous event information

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed all upcoming shows

Scenario: Edit Upcoming Event
  And I set up a basic event without registration required to go live now
  And I click save
  And I am in the studio
  And I go to home page
  When I go to edit my Upcoming Event
  And I edit the event title
  And I edit the event description
  And I click save
  Then I am in the studio

Scenario: Navigate to Archived Content Tab
  When I choose Archived Content from navigation bar
  Then I should be on the Archived Content Page
  And I go to edit my Archived Event
  And I edit the event title
  And I edit the event description
  And I click save

@regression @smoke @basic @dev
Feature: Home Page
  As a user
  I want to be able to browse the home page
  So that I can use all the functionalities

Background: 
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed all upcoming shows

Scenario: Check Account Info section
  Then I see Account Info section with correct labels and phone numbers

Scenario: Navigate to Upcoming Events Tab
  When I choose Upcoming Events from navigation bar
  Then I should be on the Upcoming Events Page

Scenario: Navigate to Archived Content Tab
  When I choose Archived Content from navigation bar
  And I should be on the Archived Content Page

@regression @smoke @dev
Feature: Reporting Page
  As a user
  I want to create a show and view the reporting page
  So that I can verify the reporting page works at all times

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed any event access restriction if exists
  And I removed all upcoming shows
  And I set up a basic event with registration required to go live now
  And I set adjust pre event environment on '0' minutes
  And I click save
  And I am in the studio
  And I go to home page
  And I get the reporting link
  And I go into the Studio
  And I am in the studio

Scenario: Test reporting values during preshow and live
  When I go to Event Info tab
  And I click the permalink
  And I enter guest email address
  And I Submit Registration
  And I have succesfully registered for the upcoming event
  And I go to the reporting page
  And I check the value of Total Registration Page Views
  And I check the value of Total Registrations
  And I check the value of Total Attended
  And I check the Percentage of Registrants who Attended
  And I close the reporting page
  And I go to the permalink from guest email
  And I am on the permalink page
  And I verify listener count in studio
  And I call in as host
  And I see host in switchboard
  And I go Live
  And I go to the reporting page
  And I check the value of Total Registration Page Views
  And I check the value of Total Registrations
  And I check the value of Total Attended
  And I check the Percentage of Registrants who Attended
  And I end the event
  Then I click on confirm to end the event


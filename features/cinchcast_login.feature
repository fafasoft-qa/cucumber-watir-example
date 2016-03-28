@regression @dev
Feature: Login 
  As a user
  I want to login to my account
  So I can use Cinchcast

Background: 
  Given I set the staging environment if enabled
  Given I am at the Login Page
  
Scenario: Log into Cinchcast with default user
  When I sign into cinchcast
  Then I should be on homepage
  
Scenario: Log into Cinchcast with custom user
  When I sign into cinchcast using username as "Demo2" and password as "Cinchcast!22"
  Then I should be on homepage

Scenario: Unsuccessful Login to Cinchcast with data provided
  When I sign into cinchcast using username as "kimross@cinchcast.com" and password as "incorrect"
  Then I should see an error for login

Scenario: Unsuccessful Login to Cinchcast with no username provided
  When I sign into cinchcast using username as "" and password as "kim"
  Then I should see an error for username

Scenario: Unsuccessful Login to Cinchcast with no password provided
  When I sign into cinchcast using username as "kimberlyross@cinchcast.com" and password as "" 
  Then I should see an error for password

Scenario: Unsuccessful Login to Cinchcast incorrect data
  When I sign into cinchcast with incorrect data
  Then I should see an error for login

Scenario: Unsuccessful Login to Cinchcast with no username
  When I sign into cinchcast with no username  
  Then I should see an error for username

Scenario: Unsuccessful Login to Cinchcast with no password
  When I sign into cinchcast with no password
  Then I should see an error for password

  

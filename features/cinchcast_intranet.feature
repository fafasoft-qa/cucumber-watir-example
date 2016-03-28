Feature: Intranet
 	As a user
 	I want to login to my account
 	So I can use Cinchcast

Background: 
 	Given I set the staging environment if enabled
 	Given I am at the Login Page
 	When I sign into cinchcast
 	And I should be on homepage
    And I removed all upcoming shows
 	And I go to the intranet

@qa @dev
Scenario: Set viral link and verify that it shows on permalink
    And I go to a specific clients settings
    And I enter viral link Text as "Cinchcast, Inc." and viral link URL as "http://cinchcast.com/"
    Then the client is updated
	Given I am at the Login Page
	And I should be on homepage
    And I removed all upcoming shows
    And I set up a basic event without registration required to go live now
  	And I click save
  	And I am in the studio
  	And I go to Event Info tab
  	And I click the permalink
  	When I am on the permalink page
  	And I wait '10' seconds
  	And I verify that the viral link text is displayed correctly
  	And I verify that the viral link URL is correct

  @smoke @regression @dev
  Scenario: Go to Connect Email PIN Search page and get results for both email and PIN search
    And I go to email pin search page
    And I am on email pin search page
    And I search for a PIN on Email Pin Search page
    Then I get results from Email Pin Search
    And I search for junk data on Email Pin Search page
    Then I get no results from Email Pin Search
    And I search for an Email on Email Pin Search page
    Then I get results from Email Pin Search


Feature: Guest Registration
  As a user
  I want to register for a show
  So that I can view the permalink as a registered guest

Background: 
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed any event access restriction if exists
  And I removed all upcoming shows

@basic @smoke @regression @dev
Scenario: Register as a guest with an email address in preshow without custom registration description
  And I set up a basic event with registration required to go live now
  And I set adjust pre event environment on '0' minutes
  And I click save
  And I am in the studio
  And I go to Event Info tab
  And I click the permalink
  And I am on Guest Registration Page
  And I see event description on Guest Registration Page
  And I enter guest email address
  And I Submit Registration
  And I have succesfully registered for the upcoming event
  And I go to the permalink from guest email
  And I am on the permalink page
  Then I see event description on Permalink Page

  @regression @dev
  Scenario: Register as a guest with an email address in preshow with custom registration description
    And I set up a basic event with registration required to go live now
    And I set a custom registration description
    And I set adjust pre event environment on '0' minutes
    And I click save
    And I am in the studio
    And I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    And I see custom registration description on Guest Registration Page
    And I enter guest email address
    And I Submit Registration
    And I have succesfully registered for the upcoming event
    And I go to the permalink from guest email
    And I am on the permalink page
    Then I see event description on Permalink Page

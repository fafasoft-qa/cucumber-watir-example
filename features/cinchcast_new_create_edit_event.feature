Feature: New Create Edit Page
  As a user
  I want to create and edit different event configurations
  So that I can verify those configurations in registration preshow live archive

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed any event access restriction if exists
  And I removed all upcoming shows

@regression @smoke @basic @dev
Scenario: To verify Create Edit page default values
  When I open Create Event page to create a new event
  And I verify the selected Tab by default
  And I verify Sunday is the first weekday on Calendar
  And I verify Event Date option for start now or later is not present anymore
  And I verify Presenter Studio Access has Start End Event option unchecked

@regression
Scenario: To verify Presenters Studio Access
  And I set up a basic event without registration required to go live now
  When I add a Presenter with Dial-In and Studio-Access
  And I click save
  Then I am in the studio
  And I am at the Login Page
  When I signout from cinchcast
  And I go to the studio from presenter email
  And I am in the studio access for presenters
@smoke2
Feature: Telephony calls and Reporting page validations in only one test
  As a user
  I want to create an event with registration required
  So that I can make sure Telephony calls and Reporting page work as expected

  Background:
    Given I set the staging environment if enabled
    Given I am at the Login Page
    And I sign into cinchcast
    And I should be on homepage
    And I removed any event access restriction if exists
    And I removed all upcoming shows

  Scenario Outline: To validate Telephony calls and Reporting metrics during Preshow, Live, Archived
    And I go to Event Access page
    And I should be on Event Access page
    And I remove all added domains
    And I set "gmail.com" for "blacklist" and save
    And I should be on homepage
    And I set up a basic event with registration required to go live now for "<toll_free>" and "<country>" phone numbers
    And I add a Presenter with Dial-In
    When I upload a preview image
    And I set adjust pre event environment on '0' minutes
    And I click save
    And I am in the studio
    And I go to Polls tab
    And I select and start a pre-existent Poll from Studio
    And I go to home page
    And I get the reporting link
    When I go to edit my Upcoming Event
    And I edit the event description
    And I upload a powerpoint PPTX with only one slide
    And I upload a video if video switch enabled
    And I click save
    And I am in the studio
    And I go to Slide tab
    And I verify slides in the timeline
    When I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    And I enter my email address as "GuestAMS@gmail.com"
    And I Submit Registration
    And I see message warning about domain is not allowed
    And I enter my email address as "GuestAMS@yahoo.com"
    And I Submit Registration
    Then I have succesfully registered for the upcoming event
    And I go to home page
    And I removed any event access restriction if exists
    And I should be on homepage
    And I go to Event Access page
    And I should be on Event Access page
    And I remove all added domains
    And I set "gmail.com" for "whitelist" and save
    And I should be on homepage
    And I go into the Studio
    And I am in the studio
    And I go to Event Info tab
    And I click the permalink
    And I am on Guest Registration Page
    When I enter my email address as "GuestAMS@yahoo.com"
    And I Submit Registration
    And I see message warning about domain is not allowed
    And I enter my email address as "GuestAMS@gmail.com"
    And I Submit Registration
    Then I have succesfully registered for the upcoming event
    And I go to the reporting page
    And I check the value of Total Registration Page Views
    And I check the value of Total Registrations
    And I check the value of Total Attended
    And I check the Percentage of Registrants who Attended
    And I close the reporting page
    And I go to the permalink from guest email
    And I am on the permalink page
    And I vote for started poll
    And I check the percentage of poll option voted
    And I verify listener count in studio
    And I call in as host
    And I wait '30' seconds
    And I see host in switchboard
    And I go Live
    Then I wait '30' seconds
    When I go to Slide tab
    Then I see the correct slide on Permalink
    When I go to Slide tab
    And I click on next slide
    Then I wait '30' seconds
    Then I see the correct slide on Permalink
    And I click on previous slide
    Then I wait '30' seconds
    Then I see the correct slide on Permalink
    And I call in as Registered Guest to "<toll_free>" and "<country>" phone number
    Then I wait '20' seconds
    And I uncheck the raise hand filter
    And I see guest in switchboard
    And I call in as Presenter to "<toll_free>" and "<country>" phone number
    And I wait '10' seconds
    And I see presenter in switchboard
    And I wait '30' seconds
    And I verify caller count in studio
    And I end the event
    And I click on confirm to end the event
    And I wait '20' seconds
    Then the webcast permalink being processed
    When I go back to the Archived view from Permalink
    When I choose Archived Content from navigation bar
    And I should be on the Archived Content Page
    Then I see already processed webcast on archived content view
    And I go to the reporting page
    And I check the value of Total Registration Page Views
    And I check the value of Total Registrations
    And I check the value of Total Attended
    And I check the Percentage of Registrants who Attended
    And I check Duration for calls
    And I close the reporting page

  Examples:
    | toll_free | country |
    | Toll | US      |
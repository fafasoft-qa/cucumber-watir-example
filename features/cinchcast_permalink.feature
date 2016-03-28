Feature: Permalink Page
  As a user
  I want to create a show and go into studio
  So that I can verify the permalink page

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed any event access restriction if exists
  And I removed all upcoming shows
  And I set up a basic event without registration required to go live now

@regression @dev
Scenario: To verify permalink autoplay when navigating to permalink during pre show , Guest registration Off
  And I upload a powerpoint PPTX
  And I upload and append additional PPTX slides
  And I upload and replace previous PPTX slides
  And I click save
  And I am in the studio
  And I go to Slide tab
  And I verify slides in the timeline
  And I go to Event Info tab
  And I click the permalink
  And I am on the permalink page
  And I wait '10' seconds
  And I am in preshow on permalink
  And I wait '15' seconds
  And I verify listener count in studio
  And I call in as host
  And I wait '20' seconds
  And I see host in switchboard
  Then I go Live
  Then I wait '10' seconds
  When I go to Slide tab
  Then I see the correct slide on Permalink
  Then I wait '10' seconds
  And I end the event
  And I click on confirm to end the event

@regression @dev
Scenario: To verify permalink webcast processes
  And I upload a video if video switch enabled
  And I upload a powerpoint PPTX
  And I click save
  And I am in the studio
  And I go to Slide tab
  And I verify slides in the timeline
  And I go to Event Info tab
  And I click the permalink
  And I am on the permalink page
  And I wait '10' seconds
  And I am in preshow on permalink
  And I wait '15' seconds
  And I verify listener count in studio
  And I call in as host
  And I wait '20' seconds
  And I see host in switchboard
  Then I go Live
  Then I wait '10' seconds
  When I go to Slide tab
  Then I see the correct slide on Permalink
  When I go to Slide tab
  And I click on next slide
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  And I click on previous slide
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  And I end the event
  And I click on confirm to end the event
  And I wait '20' seconds
  Then the webcast permalink being processed

@regression @smoke @basic @dev
Scenario: To verify Permalink autoplay during Live and Archived Content
  And I upload a video if video switch enabled
  And I upload a PDF
  And I click save
  And I am in the studio
  And I go to Slide tab
  And I verify slides in the timeline
  And I call in as host
  And I wait '20' seconds
  And I see host in switchboard
  Then I go Live
  Then I wait '10' seconds
  And I go to Event Info tab
  And I click the permalink
  And I am on the permalink page
  And I wait '15' seconds
  And I verify listener count in studio
  Then I see the correct slide on Permalink
  When I go to Slide tab
  And I click on next slide
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  And I click on previous slide
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  And I end the event
  And I click on confirm to end the event
  When I choose Archived Content from navigation bar
  And I should be on the Archived Content Page
  Then I see already processed webcast on archived content view
  And I click on permalink link on archived content view
  And I am on the permalink page
  Then I see already processed webcast on permalink page
  When I go back to Archived Content view
  And I should be on the Archived Content Page
  When I click on Download mp3 button if environment is not Production
  Then I am on Download mp3 page if environment is not Production

@regression @dev
Scenario:  To verify permalink autoplay when navigating to show during live, Guest registration ON
  And I turn on guest registration
  And I click save
  And I am in the studio
  And I go to Slide tab
  And I upload PPT slides in studio
  And I verify slides in the timeline
  And I call in as host
  And I wait '20' seconds
  And I see host in switchboard
  Then I go Live
  Then I wait '10' seconds
  And I go to Event Info tab
  And I click the permalink
  And I am on Guest Registration Page
  And I enter guest email address
  And I Submit Registration
  And I am on the permalink page
  Then I wait '10' seconds
  And I verify listener count in studio
  Then I see the correct slide on Permalink
  When I go to Slide tab
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  When I click on next slide
  Then I wait '10' seconds
  Then I see the correct slide on Permalink
  Then I wait '10' seconds
  And I end the event
  And I click on confirm to end the event
@dev @studio_features
Feature: Studio Features
  As a user
  I want to verify studio features
  So that I can validate they work properly

Background:
  Given I set the staging environment if enabled
  Given I am at the Login Page
  And I sign into cinchcast
  And I should be on homepage
  And I removed all upcoming shows
  And I set up a basic event without registration required to go live now

@regression
  Scenario: Host and Presenters' Chat
  And I click save
  And I am in the studio
  And I go to Chat tab
  And I enter host nickname and "private" chat message for "host1"
  And I see host nickname and "private" chat message for "host1"
  And I open another Studio page for same event
  And I go to Chat tab
  And I enter host nickname and "private" chat message for "host2"
  And I see host nickname and "private" chat message for "host2"
  And I go back to the first Studio page
  And I see host nickname and "private" chat message for "host1"
  And I see host nickname and "private" chat message for "host2"

@smoke @regression
  Scenario: Public Chat
    And I set public chat on
    And I click save
    And I am in the studio
    And I go to Chat tab
    And I enter host nickname and "public" chat message for "host1"
    And I see host nickname and "public" chat message for "host1"
    And I go to Event Info tab
    And I click the permalink
    And I am on the permalink page
    And I see nickname and chat message for "host1" on permalink chat
    And I enter a chat message for "anonymous" on permalink chat
    And I wait '3' seconds
    And I see nickname and chat message for "anonymous" on permalink chat
    And I go back to the first Studio page
    And I go to Chat tab
    And I see host nickname and "public" chat message for "host1"
    And I see host nickname and "public" chat message for "anonymous"

  @smoke @regression
  Scenario: Select pre-existing Poll on Studio and verify it on Permalink and voting percentage updated
    And I click save
    And I am in the studio
    And I go to Polls tab
    And I select and start a pre-existent Poll from Studio
    And I go to Event Info tab
    And I click the permalink
    And I am on the permalink page
    And I vote for started poll
    And I check the percentage of poll option voted
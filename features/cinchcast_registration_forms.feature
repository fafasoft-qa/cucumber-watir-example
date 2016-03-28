Feature: Registration Forms
  As a user
  I want to be able to create and edit registration forms
  So that I can customized them to my needs

  Background:
    Given I set the staging environment if enabled
    Given I am at the Login Page
    And I sign into cinchcast
    And I should be on homepage
    And I removed all upcoming shows
    And I select Manage registration forms from login name drop-down menu

  @smoke @regression @dev
    Scenario: Add New Form with Standard Questions
      When I click on Add New Form button
      Then Manage Registration Forms page shows
      And I name the form
      And I add standard questions to the form
      And I save the form
      Then I see my newly created registration form listed
    
    @ignore
    Scenario: Add New Form with Standard Questions required
      When I click on Add New Form button
      Then Manage Registration Forms page shows
      And I name the form
      And I add standard questions to the form
      And I mark them as required
      Then I should see a little start above the question
      And I save the form
      Then I see my newly created registration form listed

    @regression @dev
    Scenario: Add New Form with Standard Questions with Help Text
      When I click on Add New Form button
      Then Manage Registration Forms page shows
      And I name the form
      And I add standard questions to the form
      And I type in some text in Help Text field
      Then I see the text right below the question
      And I save the form
      Then I see my newly created registration form listed

    @regression @dev
    Scenario: Add New Form with Standard Question with Default answer
      When I click on Add New Form button
      Then Manage Registration Forms page shows
      And I name the form
      And I add standard questions to the form
      And I type in some text in Default Answer
      Then I should see the text in the question field
      And I save the form
      Then I see my newly created registration form listed
    
    @ignore
    Scenario: Edit registration forms
      When I select a previously created registration form
      And I can edit the Form Name
      And I select a question
      #And I can mark-unmark them as required if they are not
      And I can edit Help Text in questions
      And I can edit Default Answer
      And I save the form
      Then I can check that form kept changes made





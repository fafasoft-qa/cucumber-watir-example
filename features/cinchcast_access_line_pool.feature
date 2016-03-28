Feature: Telephony Pool
  As a user
  I want to add and delete lines from the summon access line pool
  So I use the service
  With countries culture code US, CA, GB, SE, USCA, DE, RU

  Scenario Outline: Add a Line
    And I add a number to the pool using country culture code "<arg>"
#    Then I delete a number from the pool
  Examples:
    |arg|
    |US|
    |CA|
    |GB|
    |SE|
    |USCA|
    |DE|
    |RU|

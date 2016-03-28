Feature: Telephony Provisioning
  As a user
  I want to add and delete lines from the summon access line pool
  So I use the service
  With countries culture code US, CA, GB, SE, USCA, DE, RU

  Scenario Outline: Add a Line
    And I add a number to the pool using "<country_culture>","<carrier>","<tollfree>","<quantity>","<termination_ip>"
    #Then I delete a number from the pool
  Examples:
    | country_culture | carrier | tollfree | quantity | termination_ip |
    |US|level3ams|false|100|termination_ip|
    #|RU|level3ams|true|2|termination_ip|
    #|USCA|level3ams|true|2|termination_ip|
    #|DE|level3ams|true|2|termination_ip|
    #|SE|level3ams|true|2|termination_ip|
    #|CA|level3ams|true|5|termination_ip|


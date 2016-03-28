@api @dev
Feature: Reporting API
  As a user
  I want to Access my reports using the WEB API
  So Connect to the Service

  @basic @smoke @regression
  Scenario: Try to access report with Valid MediaID&Valid Public Key&Valid Private Key&Valid Uri&Valid Rest Method
    Then I access the report api with  "GET"

  @regression
  Scenario Outline: Try to access report with Valid MediaID&Valid Public Key&Valid Private Key&Valid Uri&Invalid Rest Method
    Then I request the report with  an invalid rest method "<arg1>","<arg2>"
  Examples:
    | arg1   | arg2   |
    | POST | POST |
    | PUT | PUT |
    | DELETE | DELETE |

  @regression
  Scenario: Valid MediaID&Valid Public Key&Valid Private Key&Invalid Uri&Valid Rest Method
    Then I request the report from an invalid  uri

  @regression
  Scenario Outline:Try to access report with an invalid private key
  #Invalid Private = invalid  into key domain
    Then I request the report with an invalid private key  "<private_key>"
  Examples:
    | private_key |
    | ABCDEFGHIJKL |
    | A952404A3A314058A146795F3F359914 |
    |  |

  @regression
  Scenario Outline: Try to access report with invalid public key
  #invalid Public key  =  invalid  into key domain
    Then I request the report with an invalid public key "<public_key>"
  Examples:
    | public_key |
    | ABCDEFGHIJKL |
    | 9DA99E2B433E46FCA4EA3D66CEF3F98D |

  @regression
  Scenario Outline: Try to access report with invalid public key in header
  #invalid Public key  =  invalid  into key domain
    Then I request the report with an invalid public key "<public_key>" as header
  Examples:
    | public_key |
    | |

  @regression
  Scenario Outline: Try to access report with misspelled authorization  header
  #invalid Public key  =  invalid  into key domain
    Then I request the report with an misspelled "<authorization>"
  Examples:
    | authorization |
    | AUTHORIZATION1|

  @regression
  Scenario: Try to access report with from a user without access
  #invalid Public key  =  invalid   no have access to report
    Then I request a report from another user

  @regression
  Scenario: Try to access report using private key as public key and public key as private key
    Then I request the report with the public key as the private key and the private key as the public key

  @regression
  Scenario: Try to access report after signature time out
    Then I try to access the report after signature time out

  @regression
  Scenario Outline: Try to access report with Invalid MediaID&Valid Public Key&Valid Private Key&Valid Uri&Valid Rest Method
  #invalid MediaID = media id no valid in domain
    Then I request the report with an invalid mediaID "<mediaID>"
  Examples:
    | mediaID |
    | ABCDFRG |
    | 00000 |
    |  |


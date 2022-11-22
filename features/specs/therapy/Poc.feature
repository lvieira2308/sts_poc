@automation
@poc
Feature: Poc

  @poc
  @testcase-12 @testcase-62 @testcase-73
  Scenario: Poc
    Given I access the homepage
    When I input my email "qa+sts+therapy+test@inkblottherapy.com" and password "Test@123"
    And I click to sign in
    Then I should be authenticated  # testcase-12
    And I click to find a care provider
    And I should see the match screen  # testcase-62
    Then I should see the continue with matching button  # testcase-73






#    Then I check and interact with the individually container      # testcase-28
#    Then I check and interact with the interpersonally container   # testcase-29
#    Then I check and interact with the socially container     # testcase-31
#    Then I check and interact with the overall container   # testcase-33
#    Then I check and interact with all evaluations
#    Then I should see the personal details screen




Feature: Manage applications
  In order to learn about the kid report
  Visitors want to be able to visit public pages
  
  Scenario: View Application
    Given I am on the root page
    Then I should see "Websites for Teachers Coaches and Parents"
    
  Scenario: View About
    Given I am on the about page
    Then I should see "About us"
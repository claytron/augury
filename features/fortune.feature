Feature: Generate Fortune
  Grab a twitter feed and make it a fortune

  Scenario: Generate for a specific user
    When I run `augury generate claytron`
    Then the output should contain "something interesting I'm sure"

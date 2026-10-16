Feature: User forgot password

  Scenario: Create a valid non existing account through UI
    Given I am on the Home page
    * I fill the Email with uiForgot@example.com
    * I fill the Username with uiForgot
    * I fill the Password with uiForgot@example
    * I fill the Confirm Password with uiForgot@example
    * I check the I agree to the terms and conditions
    * I hover the Sign up button
    * I fill the Answer with 00000
    When I click the Sign up button
    Then I see Account created notification

  Scenario: Create a valid non existing account through API
    Given I send a PUT request to Create with body:
      """
      {
        "Email": "apiForgot@example.com",
        "Username": "apiForgot",
        "Password": "apiForgot@example",
        "CaptchaID": "00000",
        "CaptchaAnswer": "00000"
      }
      """
    Then the response status code should be 200
    And the response body should be:
      """
      {
        "Success": true,
        "Message": "Account created",
        "Data": null
      }
      """

  Scenario: Recover a valid existing account through UI
    Given I am on the Home page
    * I click on the Sign in button
    * I click on the Forgot Password? button
    * I fill the Email with uiForgot@example.com
    * I fill the Answer with 00000
    When I click the Send button
    Then I see Link sent. Please check your inbox notification

  Scenario: Recover a valid existing account through API
    Given I send a POST request to Forgot with body:
      """
      {
        "Email": "apiForgot@example.com",
        "CaptchaID": "00000",
        "CaptchaAnswer": "00000"
      }
      """
    Then the response status code should be 200
    And the response body should be:
      """
      {
        "Success": true,
        "Message": "Link sent. Please check your inbox",
        "Data": null
      }
      """

  Scenario: Recover a valid non existing account through UI
    Given I am on the Home page
    * I click on the Sign in button
    * I click on the Forgot Password? button
    * I fill the Email with non-existing@example.com
    * I fill the Answer with 00000
    When I click the Send button
    Then I see non-existing@example.com not found notification

  Scenario: Recover a valid non existing account through API
    Given I send a POST request to Forgot with body:
      """
      {
        "Email": "non-existing@example.com",
        "CaptchaID": "00000",
        "CaptchaAnswer": "00000"
      }
      """
    Then the response status code should be 400
    And the response body should be:
      """
      {
        "Success": false,
        "Message": "Some errors have been found.",
        "Data": [
          {
            "Type": "NotExist",
            "Message": "non-existing@example.com not found",
            "Data": {
              "Index": "non-existing@example.com"
            }
          }
        ]
      }
      """

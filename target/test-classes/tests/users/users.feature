Feature: Check users related API

Background: Preconditions
  Given url apiUrl

  Scenario: get api_string and check if its correct
    Given path '/ping'
    When method get
    Then status 200

  Scenario: Get users 
    Given path '/users'
    When method get
    Then status 200

    And match response.meta ==
    """
      {
        "per_page": "#number",
        "total": "#number",
        "previous_page_link": null,
        "count": "#number",
        "current_page": "#number",
        "next_page_link": "#string"
      }

    """
    And match each response.users  ==
    """
          {
		"availability_status": "#string",
		"wrap_up_time": "#number",
		"name": "#string",
		"available": "#boolean",
		"created_at": "#string",
		"language": "#string",
		"id": "#number",
		"time_zone": "#string",
		"direct_link": "#string",
		"email": "#string"
         }
    """

  Scenario: Create an user that already exists
    Given path '/users'
    And request 
    """
    {
      "email": "benjamin@aircall.com",
      "first_name": "Benjamin",
      "last_name": "San Miguel"
    }
    """
    When method post
    Then status 400

    And match response ==
        """
      {
          "troubleshoot": "#string",
          "error": "#string"
      }
        """

   Scenario: Create a new user, modify and delete it

    Given path '/users'
    And request 
    """
    {
      "email": "aircatrwqell@qwdes.aircall",
      "first_name": "Benjamin",
      "last_name": "SanMiguel"
    }
    """
    When method post
    Then status 201
    And match response ==
    """
  {
    "user": {
      "id": "#number",
      "direct_link": "#string",
      "name": "#string",
      "email": "#string",
      "available": "#boolean",
      "availability_status": "#string",
      "created_at": "#string",
      "time_zone": "#string",
      "language": "#string",
      "numbers": [],
      "wrap_up_time": "#number"
    }
  }
    """

      * def userId = response.user.id
      
      Given path '/users/'+userId
      And request
      """
        {
      "first_name": "Ben Updated",
        }
      """

      When method put
      Then status 200
      And match response.user.name == "Ben Updated SanMiguel"

      
      Given path '/users/'+userId
      When method delete
      Then status 204

   Scenario: Retrieve list of users availability
    Given path '/users/availabilities'
    When method get
    Then status 200
    And match response.meta ==
    """
      {
        "per_page": "#number",
        "total": "#number",
        "previous_page_link": null,
        "count": "#number",
        "current_page": "#number",
        "next_page_link": "#string"
      }
    """
    And match each response.users  ==
    """
        {
          "availability" : "#string",
          "id" : "#number"
        }
    """

   Scenario: Start a call, at this moment, I cant find the number_id associated to the phone number, so it's failing
    Given path '/users/620665/calls'
    And request 
    """
    {
      "number_id": null,
      "to": "+33652556756"
    }
    """
    When method post
    Then status 204

   Scenario: Dial a phone number, it's failing because the user is unavailable
    Given path '/users/620665/dial'
    And request
    """
    {
       "to": "+33652556756"
    }
    """
    When method post
    Then status 204
  


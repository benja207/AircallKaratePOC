Feature: Check teams related API

Background: Preconditions
    Given url apiUrl

Scenario: Retrieve all teams list, then retrieve just one, then do the same with an invalid team
    Given path '/teams'
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
        "next_page_link": null
      }

    """
    And match each response.teams ==
    """
    {
      "id": "#number",
      "name": "#string",
      "direct_link": "#string",
      "created_at": "#string",
      "users": []
    }
    """
    * def teamID = response.teams[0].id
    Given path "/teams/"+teamID
    When method get
    Then status 200
    And match response.team ==
    """
    {
        "id": "#number",
        "name": "#string",
        "direct_link": "#string",
        "created_at": "#string",
        "users": []
    }
    """
    * def invalidID = "123"
    Given path "/teams/"+invalidID
    When method get
    Then status 404

Scenario: Create a team, add an user, delete user, then delete team
    Given path "/teams"
    And request
    """
    {
      "name": "Testing12 Aircall"
    }
    """
    When method post
    Then status 201
    And match response.team ==
    """
    {
        "id": "#number",
        "name": "#string",
        "direct_link": "#string",
        "created_at": "#string",
        "users": []
    }
    """
    * def teamID = response.id
    Given path "/teams/"+teamID+"/users/620665"
    When method post 
    Then status 201
    And match response.team ==
    """
    {
        "id": "#number",
        "name": "#string",
        "direct_link": "#string",
        "created_at": "#string",
        "users": []
    }
    """
    And match response.team.users ==
    """
        {
        "id": "#number",
        "direct_link": "#string",
        "name": "#string",
        "email": "#string",
        "available": "#boolean",
        "availability_status": "#string",
        "created_at": "#string",
        "time_zone": "#string"
        }
    """
    Given path "/teams/"+teamID+"/users/620665"
    When method delete
    Then status 200
    And match response.team ==
    """
    {
        "id": "#number",
        "name": "#string",
        "direct_link": "#string",
        "created_at": "#string",
        "users": []
    }
    """
    Given path "/teams"+teamID
    When method delete
    Then status 200
        
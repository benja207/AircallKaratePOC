Feature: Check contacts related API

Background: Preconditions
    Given url apiUrl

Scenario: Get list of all contacts. Response emails fails because some emails values are not filled
    Given path '/contacts'
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
    And match each response..emails ==
    """
        {
			"id": "#number",
			"label": "#string",
			"value": "#string"
		}
      """  
          
Scenario: Search contacts
    Given path '/contacts/search?email=support@aircall.io'
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
    And match response.contacts[0].emails ==
    """
    [{
 		"id": "#number",
 		"label": "#string",
 		"value": "#string"
    }]
      """     
    And match response.contacts[0].phone_numbers ==
        """
    [{
        "id": "#number",
        "label": "#string",
        "value": "#string"
    }]
        """       
            
Scenario: Retrieve a contact
    Given path '/contacts/24634067'
    When method get
    Then status 200
    And match response.contact ==
    """
    {
        "emails": [{
			"id": "#number",
			"label": "#string",
			"value": "#string"
		}],
		"phone_numbers": [{
			"id": "#number",
			"label": "#string",
			"value": "#string"
		}],
		"updated_at": "#number",
		"company_name": "#string",
		"is_shared": "#boolean",
		"last_name": "#string",
		"created_at": "#number",
		"information": "#string",
		"id": "#number",
		"direct_link": "#string",
		"first_name": "#string"
	}
    """

Scenario: Create a contact, update it, add a phone number, update it, delete phone number, then and delete user
    Given path '/contacts'
    And request
    """
    {
    "first_name": "Benjamin",
    "last_name": "San Miguel",
    "information": "hey",
    "phone_numbers": [
        {
        "label": "Work",
        "value": "+34664673697"
        }
    ],
    "emails": [
        {
        "label": "Office",
        "value": "benjamin.sanmiguel@acme.com"
        }
    ]
    }
    """
    When method post
    Then status 201
    And match response ==
    """
{
  "contact": {
    "id": "#number",
    "direct_link": "#string",
    "first_name": "#string",
    "last_name": "#string",
    "company_name": null,
    "information": "#string",
    "is_shared": "#boolean",
    "created_at": "#number",
    "updated_at": "#number",
    "emails": [
      {
        "id": "#number",
        "label": "#string",
        "value": "#string"
      }
    ],
    "phone_numbers": [
      {
        "id": "#number",
        "label": "#string",
        "value": "#string"
      }
    ]
  }
}
    """
    * def userID = response.contact.id

    Given path '/contacts/'+userID
    And request
    """
    {
    "first_name": "Benjamin UPDATED",
    "company_name": "Aircall UPDATED"
    }
    """
    When method post
    Then status 200

    And match response ==
    """
        {
            "contact": {
                "emails": [{
                    "id": "#number",
                    "label": "#string",
                    "value": "#string"
                }],
                "phone_numbers": [{
                    "id": "#number",
                    "label": "#string",
                    "value": "#string"
                }],
                "updated_at": "#number",
                "company_name": "Aircall UPDATED",
                "is_shared": true,
                "last_name": "#string",
                "created_at": "#number",
                "information": "#string",
                "id": "#number",
                "direct_link": "#string",
                "first_name": "Benjamin UPDATED"
            }
        }
    """

    Given path '/contacts/'+userID+'/phone_details'
    And request
    """
        {
        "label": "Home",
        "value": "+18004444444"
        }
    """
    When method post
    Then status 201
    And match response ==
    """
        {
        "phone_detail": {
            "id": "#number",
            "label": "Home",
            "value": "18004444444"
        }
        }
    """

    * def phoneNumberIdUpdated = response.phone_detail.id
    Given path '/contacts/'+userID+'/phone_details/'+phoneNumberIdUpdated
    And request
    """
        {
        "label": "HomeUpdated",
        "value": "+19142329901"
        }
    """
    When method put
    Then status 202
    And match response ==
    """
        {
        "phone_detail": {
            "id": "#number",
            "label": "HomeUpdated",
            "value": "19142329901"
        }
        }
    """
    * def phoneNumberNewIdUpdated = response.phone_detail.id

    Given path '/contacts/'+userID+'/phone_details/'+phoneNumberNewIdUpdated
    When method delete
    Then status 204

    Given path '/contacts/'+userID
    When method delete
    Then status 204
    
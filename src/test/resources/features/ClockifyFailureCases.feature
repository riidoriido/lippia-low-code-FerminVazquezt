@Clockify
@Failures

Feature: Clockify API - Testing "Time Tracker" errors. (tp final)

  Background: Testing required failures
    Given base url env.base_url_clockify
    And header Content-type = application/json
    And header Accept = */*


  @GetWorkspaces400
  Scenario: 400 Bad Request cause: Missing body (wrong method)
    Given endpoint api/v1/workspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When execute method POST
    And the status code should be 400
    Then response should be message contains Required request body is missing

  @GetWorkspaces401
  Scenario: 401 Unauthorized cause: Invalid API key
    Given endpoint api/v1/workspaces
    And header x-api-key = *
    When execute method GET
    And the status code should be 401
    Then response should be message contains Api key does not exist

  @GetWorkspaces404
  Scenario: 404 Not found cause: misspelled endpoint.
    Given endpoint api/workspace
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When execute method GET
    And the status code should be 404
    Then response should be error contains Not Found

  @GetUsers405
  Scenario: 405 Method not allowed cause: Using PUT instead of GET
    Given call Clockify.feature@GetWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/users
    When execute method PUT
    And the status code should be 405
    Then response should be message contains Request method 'PUT' is not supported

  @GetUsers401
  Scenario: 401 Unauthorized cause: Missing API key
    Given call Clockify.feature@GetWorkspaces
    And endpoint api/v1/workspaces/{{workspaceId}}/users
    When execute method GET
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @GetUsers404
  Scenario: 404 Not found cause: misspelled endpoint.
    Given call Clockify.feature@GetWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/
    When execute method GET
    And the status code should be 404
    Then response should be error contains Not Found

  @GetProjects400
  Scenario: Bad Request 400 cause: Required request body is missing.
    Given call Clockify.feature@ListWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/projects
    When execute method POST
    And the status code should be 400
    Then response should be message contains Required request body is missing

  @GetProjects401
  Scenario: 401 Unauthorized cause: Missing token.
    Given endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects
    When execute method GET
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @GetProjects404
  Scenario: 404 Not found cause: Not found, misspelled endpoint.
    Given endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/project/
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When execute method GET
    And the status code should be 404
    Then response should be error contains Not Found

  @FindProjectByID400
  Scenario: 400 Bad Request cause: Project ID isn't found in workspace.
    Given call Clockify.feature@GetProjects
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects/induce_error
    When execute method GET
    Then the status code should be 400

  @FindProjectByID401
  Scenario: Unauthorized 401 cause: Wrong spelling in required key ("xapikey" instead of "x-api-key")
    Given call Clockify.feature@GetProjects
    And header xapikey = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/653a947f9b692d10ffd6d1fb
    When execute method GET
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @FindProjectByID404
  Scenario: 404 Not found cause: Not found, incomplete endpoint.
    Given call Clockify.feature@GetProjects
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/projects/653a947f9b692d10ffd6d1fb
    When execute method GET
    And the status code should be 404
    Then response should be error contains Not Found

  @GetTimeEntries400
  Scenario: 400 Bad request cause: User ID has an invalid format
    Given call Clockify.feature@GetUsers
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/user/{{userId}}aaa/time-entries
    When execute method GET
    Then the status code should be 400
    Then response should be message contains invalid hexadecimal representation of an ObjectId

  @GetTimeEntries403
  Scenario: 403 Forbidden: Invalid Workspace ID
    Given call Clockify.feature@GetUsers
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}test/user/{{userId}}/time-entries
    When execute method GET
    And the status code should be 403
    Then response should be message contains Access Denied

  @GetTimeEntries401
  Scenario: 401 Unauthorized: Missing API key
    Given call Clockify.feature@GetUsers
    And endpoint api/v1/workspaces/{{workspaceId}}test/user/{{userId}}/time-entries
    When execute method GET
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @AddTimeEntry400
  Scenario: 400 Bad Request: Invalid value in request body
    Given call Clockify.feature@GetWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries
    And body AddTimeEntry400.json
    When execute method POST
    Then the status code should be 400

  @AddTimeEntry401
  Scenario: 401 Unauthorized: Missing API key
    Given call Clockify.feature@GetWorkspaces
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries
    And body NewTimeEntry.json
    When execute method POST
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @AddTimeEntry404
  Scenario: 404 Not found cause: Not found, misspelled endpoint.
    Given call Clockify.feature@GetWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/timeentries
    And body NewTimeEntry.json
    When execute method POST
    And the status code should be 404
    Then response should be error contains Not Found

  @EditTimeEntry400
  Scenario: Bad Request 400 cause: Required request body is missing.
    Given call Clockify.feature@GetTimeEntries
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
    When execute method PUT
    And the status code should be 400
    Then response should be message contains Required request body is missing

  @EditTimeEntry401
  Scenario: 401 Unauthorized: Missing API key
    Given call Clockify.feature@GetTimeEntries
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
    And body EditTimeEntry.json
    When execute method PUT
    And the status code should be 401
    Then response should be message contains Multiple or none auth tokens present

  @EditTimeEntry
  Scenario: 405 Method not allowed cause: Incomplete endpoint matches another request
    Given call Clockify.feature@GetTimeEntries
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/
    And body EditTimeEntry.json
    When execute method PUT
    And the status code should be 405
    Then response should be message contains Request method 'PUT' is not supported

  @DeleteTimeEntry400
  Scenario: 400 Bad Request cause: Requested Time entry ID isn't found in workspace.
    Given call Clockify.feature@GetTimeEntries
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}test
    When execute method DELETE
    And the status code should be 400
    Then response should be message contains TIMEENTRY with id 655257cec7d58825176fe4cbtest doesn't belong to WORKSPACE with id 655256d78977412330a37109

  @DeleteTimeEntry403
  Scenario: 403 Forbidden: Invalid Workspace ID
    Given call Clockify.feature@GetTimeEntries
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/null/time-entries/{{timeEntryId}}
    When execute method DELETE
    And the status code should be 403
    Then response should be message contains Access Denied

  @DeleteTimeEntry401
  Scenario: 401 Unauthorized: Wrong API key
    Given call Clockify.feature@GetTimeEntries
    And header x-api-key = OGI1NzZiMzAtOWU2NaaaMzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/null/time-entries/{{timeEntryId}}
    When execute method DELETE
    And the status code should be 401
    Then response should be message contains Api key does not exist
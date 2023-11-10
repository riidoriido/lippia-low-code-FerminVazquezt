@ClockifyFailures

Feature: Testing failure cases on Clockify API (TP7)

  Background: Testing required failures
    Given base url env.base_url_clockify
    And header Content-type = application/json
    And header Accept = */*


  @ListWorkspaces400 #Bad Request 400 cause: Required request body is missing// POST used instead of GET.
  Scenario: Get all workspaces
    Given endpoint api/v1/workspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When execute method POST
    Then the status code should be 400

  @ListWorkspaces401 #Unauthorized 401 cause: Invalid API key.
  Scenario: Get all workspaces
    Given endpoint api/v1/workspaces
    And header x-api-key = *
    When execute method GET
    Then the status code should be 401

  @ListWorkspaces404 #Not found 404 cause: Not found, misspelled endpoint.
  Scenario: Get all workspaces
    Given endpoint api/workspace
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When execute method GET
    Then the status code should be 404

  @CreateWorkspace400 #Bad Request 400 cause: Workspace name is required.
  Scenario: Create workspace
    Given endpoint api/v1/workspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When body /failure_cases/CreateWorkspace400.json
    When execute method POST
    Then the status code should be 400

  @CreateWorkspace401 #Unauthorized 401 cause: Missing token.
  Scenario: Create workspace
    Given endpoint api/v1/workspaces
    When body AddWorkspace.json
    When execute method POST
    Then the status code should be 401

  @CreateWorkspace404  #Not found 404 cause: Not found, incomplete endpoint.
  Scenario: Create workspace
    Given endpoint api/v1/
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    When body AddWorkspace.json
    When execute method POST
    Then the status code should be 404

  @CreateProject400 #Bad Request 400 cause: Name already exists.
  Scenario: Create project in specific Workspace
    Given base url env.base_url_clockify
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects/
    And body /failure_cases/NewProject400.json
    When execute method POST
    Then the status code should be 400

  @CreateProject401 #Unauthorized 401 cause: Missing token.
  Scenario: Create project in specific Workspace
    Given base url env.base_url_clockify
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects/
    And body NewProject.json
    When execute method POST
    Then the status code should be 401

  @CreateProject404 #Not found 404 cause: Not found, misspelled endpoint.
  Scenario: Create project in specific Workspace
    Given base url env.base_url_clockify
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/project/
    And body NewProject.json
    When execute method POST
    Then the status code should be 404

  @GetProjects400 #Bad Request 400 cause: Required request body is missing// POST used instead of GET.
  Scenario: Get all projects inside workspace
    Given call Clockify.feature@ListWorkspaces
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects
    When execute method POST
    Then the status code should be 400

  @GetProjects401 #Unauthorized 401 cause: Missing token.
  Scenario: Get all projects inside workspace
    Given base url env.base_url_clockify
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects
    When execute method GET
    Then the status code should be 401

  @GetProjects404 #Not found 404 cause: Not found, misspelled endpoint.
  Scenario: Get all projects inside workspace
    Given base url env.base_url_clockify
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/project/
    When execute method GET
    Then the status code should be 404

  @FindProjectByID400 #Bad Request 400 cause: Project ID isn't found in workspace.
  Scenario: Get specific project by its ID
    Given call Clockify.feature@GetProjects
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects/induce_error
    When execute method GET
    Then the status code should be 400

  @FindProjectByID401 #Unauthorized 401 cause: Missing token.//Wrong spelling in required key ("xapikey" instead of "x-api-key")
  Scenario: Get specific project by its ID
    Given call Clockify.feature@GetProjects
    And header xapikey = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/653a91fd9aa6dc598ef16102/projects/653a947f9b692d10ffd6d1fb
    When execute method POST
    Then the status code should be 401

  @FindProjectByID404 #Not found 404 cause: Not found, incomplete endpoint.
  Scenario: Get specific project by its ID
    Given call Clockify.feature@GetProjects
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/projects/653a947f9b692d10ffd6d1fb
    When execute method POST
    Then the status code should be 404

  @UpdateProject400 #Bad Request 400 cause: Required request body is missing.
  Scenario: Update project details
    Given call Clockify.feature@GetProject
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/653a947f9b692d10ffd6d1fb
    When execute method PUT
    Then the status code should be 400

  @UpdateProject401 #Unauthorized 401 cause: Missing token.
  Scenario: Update project details
    Given call Clockify.feature@GetProject
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/653a947f9b692d10ffd6d1fb
    When execute method PUT
    Then the status code should be 401

  @UpdateProject404 #Not found 404 cause: Not found, misspelled endpoint.
  Scenario: Update project details
    Given call Clockify.feature@GetProject
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/project/653a947f9b692d10ffd6d1fb
    When execute method PUT
    Then the status code should be 404

  @UpdateMemberships400 #Bad request 400 cause: Required request body is missing.
  Scenario: Update project value: memberships
    Given call Clockify.feature@GetProject
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}/memberships
    And body /failure_cases/UpdateMemberships400.json
    When execute method PATCH
    Then the status code should be 400

  @UpdateMemberships401 #Unauthorized 401 cause: API key non-existent.
  Scenario: Update project value: memberships
    Given call Clockify.feature@GetProject
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2Z$$$$$
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}/memberships
    And body EditMemberships.json
    When execute method PATCH
    Then the status code should be 401

  @UpdateMemberships404 #Not found 404 cause: Not found, misspelled endpoint.
  Scenario: Update project value: memberships
    Given call Clockify.feature@GetProject
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}/memberships_typo
    And body EditMemberships.json
    When execute method PATCH
    Then the status code should be 404
@Clockify
Feature: Test Clockify API

  Background: Testeamos los diferentes endpoints de la API
    Given base url env.base_url_clockify
    And header Content-type = application/json
    And header Accept = */*
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl

  @ListWorkspaces
  Scenario: Get all workspaces
    Given endpoint api/v1/workspaces
    When execute method GET
    Then the status code should be 200
    * define workspaceId = $.[3].id

  @CreateWorkspace
  Scenario: Create workspace
    Given endpoint api/v1/workspaces
    When body AddWorkspace.json
    When execute method POST
    Then the status code should be 201

  @CreateProject
  Scenario: Create project in specific Workspace
    Given call Clockify.feature@ListWorkspaces
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects
    And body NewProject.json
    When execute method POST
    Then the status code should be 201

  @GetProject
  Scenario: Get specific project inside workspace
    Given call Clockify.feature@ListWorkspaces
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects
    When execute method GET
    Then the status code should be 200
    * define projectId = $.[0].id

  @UpdateProject
  Scenario: Update project details
    Given call Clockify.feature@GetProject
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}
    And body EditProject.json
    When execute method PUT
    Then the status code should be 200

  @UpdateMemberships
  Scenario: Update project value: memberships
    Given call Clockify.feature@GetProject
    And base url env.base_url_clockify
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}/memberships
    And body EditMemberships.json
    When execute method PATCH
    Then the status code should be 200

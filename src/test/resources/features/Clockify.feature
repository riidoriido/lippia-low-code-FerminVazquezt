@Clockify
@SuccessCases
Feature: Clockify API - Testing "Time Tracker" features. (tp final)

  Background: Testing required endpoints
    Given base url env.base_url_clockify
    And header Content-type = application/json
    And header Accept = */*
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl


  @GetWorkspaces
  Scenario: Get all workspaces
    Given endpoint api/v1/workspaces
    When execute method GET
    Then the status code should be 200
    * define workspaceId = $.[6].id

  @GetUsers
  Scenario: Get users from workspace
    Given call Clockify.feature@GetWorkspaces
    And endpoint api/v1/workspaces/{{workspaceId}}/users
    When execute method GET
    Then the status code should be 200
    * define userId = $.[0].id

  @GetProjects
  Scenario: Get projects inside workspace
    Given call Clockify.feature@ListWorkspaces
    And endpoint api/v1/workspaces/{{workspaceId}}/projects
    When execute method GET
    Then the status code should be 200
    * define projectId = $.[0].id

  @FindProjectByID
  Scenario: Get specific project by its ID
    Given call Clockify.feature@GetProjects
    And endpoint api/v1/workspaces/{{workspaceId}}/projects/{{projectId}}
    When execute method GET
    And the status code should be 200
    Then response should be $.name = tpFinalLippia

  @GetTimeEntries
  Scenario: Get user specific time entries in workspace
    Given call Clockify.feature@GetUsers
    And endpoint api/v1/workspaces/{{workspaceId}}/user/{{userId}}/time-entries
    When execute method GET
    Then the status code should be 200
    * define timeEntryId = $.[0].id

  @AddTimeEntry
  Scenario: Add a time entry to a workspace
    Given call Clockify.feature@GetWorkspaces
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries
    And body NewTimeEntry.json
    When execute method POST
    And the status code should be 201
    Then response should be $.description = TimeEntry created from Lippia

  @EditTimeEntry
  Scenario: Edit values from an existent time entry
    Given call Clockify.feature@GetTimeEntries
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
    And body EditTimeEntry.json
    When execute method PUT
    And the status code should be 200
    Then response should be $.timeInterval.duration = PT9H


  @DeleteTimeEntry
  Scenario: Delete a time entry from a workspace
    Given call Clockify.feature@GetTimeEntries
    And endpoint api/v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
    When execute method DELETE
    Then the status code should be 204
@ClockifyFailures

Feature: Testing failure cases on Clockify API (tp #7)

  Background: Testing required endpoints
    Given base url env.base_url_clockify
    And header Content-type = application/json
    And header Accept = */*
    And header x-api-key = OGI1NzZiMzAtOWU2Ni00MzFjLWI0MmItYjMzYzQyN2ZiZWFl
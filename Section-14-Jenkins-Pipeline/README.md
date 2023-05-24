# Introduction to jenkins pipeline

- https://www.jenkins.io/doc/book/pipeline/

- ![image](https://github.com/nayanrajani/Terraform/assets/57224583/1a86fc3c-a472-4676-a9da-7fe8fd747717)

- there are two types of pipelines
  - Declarative (super good for beginner)
  - Scripted (more complicated)

## Install the Jenkins Pipeline Plugin

- Already installed.

### Create your first Pipeline

- check pipeline-templates for this

- in jenkins
  - create a new item -> pipeline-template -> choose pipeline -> ok
    - go to Pipeline section
      - paste the script from first-pipeline from pipeline-template folder
    - save
    - build now
    - check build

### Add multi-steps to your Pipeline

- check multiple-steps file.
- in jenkins
  - pipeline-template
    - configure
      - pipeline
        - change the script from multiple-steps file.
    - save
    - build now
    - check build

### Retry

- check retry file.
- in jenkins
  - pipeline-template
    - configure
      - pipeline
        - change the script from retry file.
    - save
    - build now
    - check build

### Timeout

- check Timeout file.
- in jenkins
  - pipeline-template
    - configure
      - pipeline
        - change the script from Timeout file.
    - save
    - build now
    - check build

### Environment variables

- check env file.
- in jenkins
  - pipeline-template
    - configure
      - pipeline
        - change the script from env file.
    - save
    - build now
    - check build

### Credentials

- check creds file.
- in jenkins
  - manage-jenkins
    - Security
      - credentials
        - Scoped to jenkins (click on System)
          - click on Global credentials (unrestricted)
            - add credentials
              - choose secret text
                - Secret: [anything you can add]
                - ID: SECRET_TEXT
            - create
  - pipeline-template
    - configure
      - pipeline
        - change the script from creds file.
    - save
    - build now
    - check build

### Post actions

- check post-actions file.
- in jenkins
  - pipeline-template
    - configure
      - pipeline
        - change the script from post-actions file.
    - save
    - build now
    - check build
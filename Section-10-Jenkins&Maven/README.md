# Introduction: Jenkins & Maven

- https://www.javatpoint.com/maven-tutorial

## Install Plugin

- Maven Integration and chek in installed plugin is git is installer or not

### Learn how to clone a GIT/GITHUB repository from Jenkins

- google-> sample maven app

- copy the URL (https://github.com/jenkins-docs/simple-java-maven-app.git)

- in jenkins
  - new item -> Maven joon -> fresstyle -> ok
  - configure -> general -> new block [SCM(Source code management)]
    - choose git
      - Repository URL: paste sample app URL
      - Credentials: default
  - save
  - build now
    - check console output
    - our code is stored in workspace under /var/jenkins_home/workspace/maven-job

- in VM (if you want to see all the workspaces or job)
- docker exec -ti jenkins bash
  - cd
  - cd /var/jenkins_home/workspace/
  - ls -l
  - cd maven-job
  - ls -l  OR ls -la

### Learn how to build a JAR using maven

- in Jenkins
  - manage jenkins
    - System Configuration -> Tools
      - Maven installations
        - Name: jenkins-maven
    - save
  - in maven-job
    - configure
      - Build
        - add build step
          - invoke top-level maven targets
            - maven version: choose jenkins-maven
            - Goals: -B -DskipTests clean package
      - save
      - build now
      - check configure output
        - scroll to bottom
          - check building jar: location copy that and check in your jenkins bash

      - check in jenkins bash

### Learn how to test your code

- in maven-job
  - configure
    - Build
      - add build step
        - invoke top-level maven targets
          - maven version: choose jenkins-maven
          - Goals: test
    - save
    - build now
    - configure output

### Deploy your Jar locally

- in maven-job
  - configure
    - Build
      - add build step
        - Execute Shell
          - Commands:
            - echo "***********"
            - echo "Deploying JAR"
            - echo "***********"
            - java -jar (copy Building Jar location from the last console output and paste it over here)

    - save
    - build now
    - configure output

- You are doing CI/CD thing properly now
  - You are retrieving the code from git
  - you are bulding your JAR
  - Testing it
  - Deploying your JAR Locally

### Display the result of your tests using a graph

- Maven is creating a report in xml, inside the workspace.
  - you can chek in console output, it provides the PATH.

- in maven-job
  - configure
    - Post build Action
      - add post build step
        - Publish JUnit test result report
          - Test report xml: target/surefire-reports/*.xml

    - save
    - build now (5 to 6 times so that graph can appear)
    - refresh the page

### Archive the last successful artifact

- in maven-job
  - configure
    - Post build Action
      - add post build step
        - Archive the Artifacts
          - files to archive: target/*.jar
            - Advanced
              - choose option for "Archive only if build successful"
    - save
    - build now
    - configure output

### Send Email notifications about the status of your maven project

- in maven-job
  - configure
    - Post build Action
      - add post build step
        - Email Notification
          - recipents: add your email
          - choose both option

    - try to make an error in shell command, to check email notification
    - save
    - build now
    - configure output

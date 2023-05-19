# Introduction: Jenkins & Maven

- https://www.javatpoint.com/maven-tutorial

## Install Plugin

- Maven Integration and chek in installed plugin is git is installer or not

###  Learn how to clone a GIT/GITHUB repository from Jenkins

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
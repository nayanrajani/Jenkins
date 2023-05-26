# Introduction

- login as a root in jenkins
  - docker exec -it --user root <container id> bash
- CI/CD + Jenkins + Docker + Maven

## Learn how to install Docker inside of a Docker Container

- In VM
  - cd jenkins-data/
  - sudo su
    - sudo service ntpd restart
    - exit
  - cd jenkins-data/
    - ll
    - mkdir pipeline
      - vi Dockerfile
        - check dockerfile inside pipeline folder
        - save
      - cd ..
    - vi docker-compose.yml
      - check docker-compose.yml
      - save
    - docker-compose build
    - docker images | grep docker
    - docker-compose up -d
    - sudo chown 1000:1000 /var/run/docker.sock
    - docker exec -ti jenkins bash
      - docker ps

### Define the steps for your Pipeline

- cd jenkins-data/
  - cd pipeline
    - vi Jenkinsfile
      - check the content in Jenkins1 file
      - save
    - ll

### Build: Create a Jar for your Maven App using Docker

- copy the simple-java-maven app from jenkins-data to pipeline folder with java-app name

- cd jenkins-data
  - cp -r simple-java-maven-app pipeline/java-app
  - cd pipeline
    - ll
    - cd java-app
      - ll -a
        - delete the .git folder to avoid overwrite on our simple-java-maven-app git repo.
      - rm -rf .git
      - cd ..
  - mkdir jenkins/build -p
  - ll
  - ls jenkins/

#### Now it's time to create a JAR file from the given code in java-app with the help of Docker

- cd jenkins-data
  - cd pipeline
    - docker pull maven:3-alpine
    - docker images | grep maven
    - docker run --rm -ti -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ maven:3-alpine sh  // to store the packages at our pipeline directory we are using /root/.m2/:/root/.m2/ to mount
      - cd /app/
        - ls -l
        - mvn package  //this will take the pox.xml file to create a JAR file.
          - ctrl + c //in middle of the download
          - ls /root/.m2/
        - exit
    - sudo ls /root/.m2/
    - docker run --rm -ti -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine sh  //directly jump into the working directory
      - exit
    - docker run --rm -v $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine mvn -B -DskipTests clean package   // removing -ti because we are directly executing from outside of the container.
      - [Error] if you get Error then change the pom.xml check pom.xml file.
    - ls /java-app/target/
      - if you remove jar file then try again it will not download all the files, it will just recreate it.
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
    - docker-compose 
    - save
- 
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
  - mkdir jenkins/
  - save-  -p
  - ll
  - ls jenkins/

  - Now it's time to create a JAR file from the given code in java-app with the help of Docker

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
      - ls java-app/target/
        - if you remove jar file then try again it will not download all the files, it will just recreate it.

### Build: Write abash script to automate the Jar creation

- cd jenkins-data/pipeline/jenkins/
- sav- 
  - vi mvn.sh
    - check mvn1.sh inside jenkins/build
    - save
  - chmod +x mvn.sh
  - cd ..
  - cd ..
  - in pipeline
    - ./jenkins/build/mvn.sh mvn -B -DskipTests clean package

### Build: Create a Dockerfile and build an image with your Jar

- cd jenkins-data/pipeline/jenkins/build
  - vi Dockerfile-java
    - check Dockerfile-java
    - save
  - cp ../../java-app/target/my-app-1.0-SNAPSHOT.jar  .
  - ls
  - docker build -f Dockerfile-java -t test .
  - docker images | grep test
  - docker run --rm -ti test sh
    - cd /app/
      - ls
    - exit
  - docker run -d test
    - copy the id
  - docker logs -f [paste-id here]
    - it will say Hello World!

### Build: Create a Docker Compose file to automate the Image build process

- cd jenkins-data/pipeline/jenkins/build
  - vi docker-compose-build.yml
    - check docker-compose-build1.yml
    - save

  - export BUILD_TAG=1
  - docker-compose -f docker-compose-build.yml build
  - docker images | grep -w app

  - export BUILD_TAG=2
  - docker-compose -f docker-compose-build.yml build
  - docker images | grep -w app

### Build: Write a bash script to automate the Docker Image creation process

- cd pipeline
  - cp java-app/target/*.jar jenkins/build
  - export BUILD_TAG=1
  - cd jenkins/build/ && docker-compose -fdocker-compose-build.yml build --no-cache
  - vi jenkins/build/build.sh
    - check build.sh
    - save
  - chmod +x jenkins/build/build.sh
  - ./jenkins/build/build.sh

### Build: Add your scripts to the Jenkinsfile

- cd pipeline
  - vi Jenkinsfile
    - check jenkinsfile2-build
    - save

### Test: Learn how to test your code using Maven and Docker

- cd pipeline
  - to test your code
  - ls java-app/target/
    - you will not find the surefire report here
  - docker run --rm -v $PWD/java-app:/app -v /root/.m2/ -w /app maven:3-alpine mvn test
  - ls java-app/target/surefire-reports/

### Test: Create a bash script to automate the test process

- cd pipeline
  - mkdir jenkins/test
    - cd jenkins/test/
      - cp ../build/mvn.sh .
      - vi mvn.sh
        - check mvn1.sh
        - save
      - chmod +x mvn.sh
      - cd ..
    - cd ..
  - ./jenkins/test/mvn.sh mvn test

### Test: Add your test script to Jenkinsfile

- cd pipeline
  - vi Jenkinsfile
    - check Jenkinsfile2-test
    - save

### Create a remote machine to deploy your containerized app

- create a VM in AWS and Install Docker and Docker-compose inside that that machine

- and login to that instance with Key-pair in CMD.
  - ssh -i key-pair-name.pem ec2-user@[public-ip-of-your-ec2-machine]
- Download docker and docker-compose
  - we are using prod-user provide permission to this
  - Check DEVOPS/Docker-install-amazon-linux-ec2/Docker-Amazon-ec2-linux.html

- create a Key with key-gen in jenkins, to access from the new VM
  - [jenkins@192 ~]$ ssh-keygen -f prod
    - enter
    - enter
  - ll
    - you will get a prod and prod.pub file.
  - cat prod.pub

- go to your newly created VM
  - sudo su prod-user
    - cd /home/prod-user
      - mkdir .ssh
        - chmod 700 .ssh/
        - vi .ssh/authorized_keys
          - paste the content of prod.pub from jenkins machine
          - remove the jenkins@[your-ip] from last
          - save
        - chmod 400 .ssh/authorized_keys
      - exit
    - exit
  - exit till logout to your local machine

- in local machine create a text file and copy and paste the contents of prod(private key) to this text file
  - prod-key
    - paste the key
    - save as prod-key.pem

- now login with this key to our machine
  - ssh -i key-name prod-user@[your-ec2-public-ip]

### Push: Create your own Docker Hub account | Push: Create a Repository in Docker Hub

- login to your account or create one dockerhub account

- click on create a repo
  - name: maven-project
  - visibility: private
  - create

### Push: Learn how to Push/Pull Docker images to your Repository

- from console of dockerhub
  - copy the push command

- in your jenkins machine
  - docker login
    - add username
    - password
      - login succeeded
  - docker images
    - let's say you want to puch app image
  - docker tag app:2 {Username}/maven-project:2
    - docker rmi <image name>
  - docker push {docker-username}/maven-project:2

### Push: Write a bash script to automate the push process

- cd jenkins-data
  - cd pipeline
    - cd jenkins
      - cd build
        - vi docker-compose-build.yml
          - check docker-compose-build.yml in jenkins/build
          - save
      - mkdir push
        - cd push
          - vi push.sh
            - check push.sh
            - save
          - chmod +x push.sh
          - export PASS={Your password}
          - export BUILD_TAG=3
          - docker tag app:2 {docker-username}/maven-project:3
          - ./push.sh
            - check on dockerhub console

### Push: Add your push script to Jenkinsfile


- cd pipeline
  - vi Jenkinsfile
    - check jenkinsfile2-push
    - save

### Deploy: Transfer some variables to the remote machine

- cd jenkins-data/
  - mkdir pipeline/jenkins/deploy
  - cd pipeline/jenkins/deploy
    - export BUILD_TAG=4
    - export PASS={your password}
    - vi deploy.sh
      - check deploy1.sh in jenkins/deploy
      - save
    - sh deploy.sh
    - cat /tmp/.auth

- to transfer the file from here to the new VM
- cd ..
  - inside jenkins@localhost or whatever
    - scp -i prod /tmp/.auth prod-user@{your-ec2-public IP}:/tmp/.auth
      - yes
      - successfully sent the file

- login to the new VM
  - ssh -i prod prod-user@{your-ec2-public-ip}
    - cat /tmp/.auth
      - if you see the file, itis done
    - exit

- cd jenkins-data/pipeline/jenkins/deploy
  - sudo cp ~/prod /opt
  - ls /opt/
  - sudo chown 1000 /opt/prod
  - vi deploy.sh
    - check deploy2.sh
    - save
  - chmod +x deploy.sh
  - ./deploy.sh

### Deploy: Deploy your application on the remote machine manually

- cd jenkins-data
  - cd pipeline
    - cd jenkins
      - cd build
        - export BUILD_TAG=5
    - ./jenkins/build/build.sh
    - docker images | grep maven
      - check maven-project with tag 5 created
    - ./jenkins/push/push.sh
      - check on docker hub console to validate
    - cd jenkins
      - cd deploy
        - ./deploy.sh
      - cd ..
    - cd ..
  - cd ..
- cd ..
- ssh -i prod prod-user@{your ec2 ip}
  - cat /tmp/.auth
  - mkdir maven
    - vi docker-compose.yml
      - check remote-docker-compose.yml
      - save
    - export IMAGE=$(sed -n '1p' /tmp/.auth)
    - export TAG=$(sed -n '2p' /tmp/.auth)
    - export PASS=$(sed -n '3p' /tmp/.auth)
    - docker login -u {docker-username} -p $PASS
    - docker-compose up -d
    - docker ps -a
    - docker logs maven-app

### Deploy: Transfer the deployment script to the remote machine (continue from above)

- continue in new VM
  - cd maven
    - vi publish
      - check publish under jenkins/deploy
      - save
    - chmod +x publish
    - ./publish
- exit

- inside jenkins
  - cd jenkins-data
    - cd pipeline
      - cd jenkins
        - deploy
          - vi publish
            - check publish file
            - save
          - vi deploy.sh
            - check deploy3.sh
            - save
          - cd..
        - cd..
      - ./jenkins/deploy/deploy.sh

### Deploy: Execute the deploy script in the remote machine

- inside jenkins
  - cd jenkins-data
    - cd pipeline
      - cd jenkins
        - deploy
          - vi deploy.sh
            - check deploy.sh
            - save
          - cd..
        - cd..
- now login to that new VM
  - cd tmp/
    - chmod +x publish

- now come back to cd jenkins-data/pipeline
  - ./jenkins/deploy/deploy.sh

### Deploy: Add your deploy script to Jenkinsfile

- cd jenkins-data/pipeline
  - vi Jenkinsfile
    - check Jenkinsfile2-deploy
    - save

### Create a Git Repository to store your scripts and the code for the app

- login to your git server
  - create a private repo pipeline-maven under jenkins group
  - add a member maintain to this repo

- inside cd jenkins-data/pipeline 
  - if you face any difficulty please unprotect the main branch inisde pipeline-maven
  - git init
  - git remote add origin http://192.168.1.10:8090/jenkins/pipeline-maven.git
  - git status
  - git add Jenkinsfile java-app/ jenkins/
  - git commit -m "Initial commit"
  - git push origin main
    - username
    - password
  - check on git-server

### Create the Jenkins Pipeline. Finally!

- login to jenkins
  - new item
    - pipeline-docker-maven
    - choose pipelin
  - ok
  - go to pipeline section
    - Definition: choose Pipeline script from SCM
      - SCM: Git
        - Repositories: 
          - repo URL:  http://git/jenkins/pipeline-maven.git
          - credential: choose maintain
          - branch: */main
  - save
  - build now (it will fail but it will clone the this repo into our local jenkins workspace folder)
  - cd jenkins-data/jenkins_home/workspace/
  - ls
  - ls pipeline-docker-maven

### Modify the path when mounting Docker volumes

- cd jenkins-data/pipeline/jenkins
  - grep -R PWD
    - [jenkins@localhost jenkins]$ grep -R PWD
      - build/mvn.sh:docker run --rm  -v  $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
      - test/mvn.sh:docker run --rm  -v  $PWD/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
  - vi build/mvn.sh
    - check build/mvn.sh
    - save
  - vi test/mvn.sh
    - check build/mvn.sh
    - save
  - git status
  - git add build/ test/
  - git commit -m "changes in build and test"
  - git push origin main
    - username
    - password

### Create the Registry Password in Jenkins

- 
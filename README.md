# Jenkins- Beginners to Advance

## Introduction & Installation

### [Jenkins](https://www.jenkins.io/)

- Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

- Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with a Java Runtime Environment (JRE) installed.

### [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

- Use a Centos 7 ISO
  - create a VM in virtual box and follow the procedure you want and select the ISO Image
  - I provided 15 GB od disk space and 2 GB of RAM.

  - After booting up you need to select via up and down arrow key and hit enter on "Install Centos 7".
  - wait for a while, with the help of tab just hit continue button with Enter.
  - click on the installation mathod and set to automatic and done
  - click on network and enable the ethernet option and done.
  - Begin Installation.
  - give root user a password and remember it.
  - create a user name as jenkins and give password as well.
  - wait for it to complete and then REBOOT.
    - login with jenkins and password
    - on login check with "ip a" and copy the IP

  - Download Putty and change appearence accordingly.
  - now open putty under session add ip in Host section
  - and enter name down and click on save
  - to open the save section, click on name, load and then open.
  - you need to login again with jenkins and password. [DO noe close the virtual box section, minimise it].

### Docker

- [Docker for CentOS](https://docs.docker.com/engine/install/centos/), make sure you have internet access on VM.
  - Ping google.com
  - change timeout for yum via root
    - sudo -i, then add password
    - vi /etc/yum.conf
      - press insert from keyboard and add below configuration incide that file after this line "distroverpkg=centos-release"
        - #add timeout here
        - timeout=120
      - esc, :wq!, this will save the file
    - exit 
  - Copy and paste the commands from link to VM.
  - Install using the rpm repository
    - sudo yum install -y yum-utils
    - sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - Install Docker Engine
    - sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      - y
      - y
    - sudo systemctl start docker
    - sudo systemctl enable docker  //to start docker at out machine boot
    - test docker
      - docker ps
        - [ERROR] permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
      - FIX
        - sudo usermod -aG docker jenkins
        - logout
      - login again
        - docker ps
  - Install Docker Compose
    - sudo curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
      - add password
    - sudo chmod +x /usr/local/bin/docker-compose    // executable permissions
    - docker-compose

- [Download Jenkins Docker Image](https://hub.docker.com/_/jenkins/)
  - docker uses an image, an image is like a snapshot of pre-configured configuration file.
  - docker pull jenkins/jenkins
    - check images
    - docker images
  - docker info | grep -i root    //where docker is saving the file.
  - sudo du -sh /var/lib/docker  // how much space is docker taking

  - Create a docker compose file for Jenkins
    - mkdir jenkins-data
    - pwd
    - ls [path]
    - cd jenkins-data/
    - ll
    - mkdir jenkins_home
    - ll/ls
    - vi docker-compose.yml
      - check jenkins-resources -> jenkins-jekins.yml
      - copy and paste
    - cat docker-compose.yml
  
  - Create a Docker container for Jenkins

    - ls -l
    - sudo chown 1000:1000 jenkins_home -R
    - docker commands to start/stop/restart
      - docker-compose up -d /docker-compose start
      - docker-compose stop
      - docker-compose restart jenkins
      - docker-compose down           //this will delete the service but not the actual file/configuration in jenkins_home
    - docker ps
    - docker logs -f [name]  //show logs for acertain containers OR it will provide the Admin Password for Jenkins
    - Access jenkins on web ->  [VM-Ip]:8080
    - Copy and paste the password
      - Continue 
      - click on install suggested plugins  // it will take a while
    - now create a Admin user and password carefully
      - save and continue
      - save and finish
      - start using jenkins
      - Logout and Login

      - [ERROR-for-Jenkins]
      - Troubleshooting: Jenkins not coming up?
      - Hey, there!
      - There's a chance that your jenkins container won't come up. If you can't see your container by using docker ps, this will - help! Otherwise, you can just ignore it :D
      - Issue:
      - docker ps doesn't show the running container.
      - Debug:
      - docker ps -a shows the container with exit status.
      - docker logs jenkins shows a volume permission error.
      - Reason:
        - Inside of the Jenkins container, there's a user named "jenkins" which has a Linux uid of 1000.
        - You are mounting a docker volume to /var/jenkins_home which is the home directory of that user. If the directory doesn't - have 1000 permissions, then the user won't be able to write/delete files, which causes the container to exit.
      - Resolution:
      - Apply 1000 permissions to your jenkins-data folder, and then restart the container.
      - sudo chown 1000:1000 -R ~/jenkins-data.
      - docker-compose up -d

  - To add a DNS name against IP:8080 (but still you need to add :8080, if machine shutdown then you need to do it again)
    - open notepad as a administrator
    - file -> open
    - got to this path -> C:\Windows\System32\drivers\etc
    - select all files and then select hosts file -> open
    - ad ip only and add a space and DNS
      ex: 192.168.0.0 jenkins.local
  
  - To run a service under the container
    - we can run below command
      - docker exec -it jenkins sh
      - java --version

## Getting Started with Jenkins

### Intro to Jenkins UI

- power up system and jenkins again
  - cd jenkins-data
  - docker-compose up -d

- Hands On! Create first Jenkins Job [A Task in Jenkins called a Job]
  - create new item
  - give name "my-first-job"
  - free-style projects
    - Build Environment
      - in the add build build setup section select  "Execute shell"
        - Echo Hello World!
      - Save
    - Click build now
    - go to build history and chek your console output

- Let's play with our first job
  - again go to configure and under build step section, print date with string
    - echo "current date is $(date)"   //whoami, 
    - repeat the steps for save and build and console output

- redirect output of first job 
  - again in shell,
    - NAME=Nayan
    - echo "Hello $NAME. The current date and Time is $(date)"

  - to redirect in a file
    - NAME=Nayan
    - echo "Hello $NAME. The current date and Time is $(date)" > /temp/info
    - cat /temp/info

- Learn how to execute a bash script from Jenkins
  - let's create a script in VM machine outside of service container ($1 and $2 are parameters we will provide)
    - vi script.sh
      #!/bin/bash
      Name=$1
      LastName=$2

      echo "Hello! $Name $LastName"

    - esc, :wq! , enter
    - chmod +x ./script.sh
    - ./script.sh Nayan Rajani
  
  - COpy the file in jenkins container
    - docker cp script.sh jenkins:/tmp/script.sh
    - docker exec -it jenkins sh
    - cat /tmp/script.sh
      - /tmp/script.sh Nayan Rajani (Execute this in first job as well)

      OR

      - Name=Nayan
      - LastName=Rajani
      - /tmp/script.sh $Name $LastName

- Add Parameters to your Job
  - 
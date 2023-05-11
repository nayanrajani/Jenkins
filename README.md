# Jenkins- Beginners to Advance

- ctrl + r (FOR Command SEARCH)
- change date
  - sudo su -
  - password
  - sudo date -s "2023-05-12 12:36:45"  //change accordingly

  OR

  - cd /usr/share/zoneinfo
  - tzselect
    - enter details accordingly

## Section-2 Introduction & Installation

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
    - yum update -y
      - if yum gets stuck "Another app is currently holding the yum lock; waiting for it to exit..."
      - check https://www.golinuxcloud.com/another-app-is-currently-holding-the-yum-lock/
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
    - docker logs -f [service-name]  //show logs for acertain containers OR it will provide the Admin Password for Jenkins
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

## Section-3 Getting Started with Jenkins

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
      - /tmp/script.sh Nayan Rajani 

      OR (Execute this in first job as well)

      - Name=Nayan
      - LastName=Rajani
      - /tmp/script.sh $Name $LastName

- Add Parameters to your Job
  - General
    - Select "This project is paramiterised"
      - Select "String Parameter"
        - Name = FIRST_NAME
        - Default Value = Nayan
      - Select "String Parameter"
        - Name = LAST_NAME
        - Default Value = Rajani
  - Build Environment
    - in the add build build setup section select  "Execute shell"
      - echo "Hello, $FIRST_NAME $LAST_NAME"
      - Save
    - Click build with parameter (Button change)
      - you can change the name it will pop-up

- How to create a List parameter
  - General
    - Select "This project is paramiterised"
      - Select "Choice Parameter"
        - Name = LASTNAME
        - choices = Rajani
                    rajani
                    Rajaani
  - Build Environment
    - in the add build build setup section select  "Execute shell"
      - echo "Hello, $FIRST_NAME $LAST_NAME"
      - Save
    - Click build with parameter (Button change)
      - you can change the name it will pop-up
    - remove this

- Add Basic Logic in Boolean Parameter
  - on the basis of true and false you will print the value from the script.sh
    - General
      - Select "This project is paramiterised"
        - Select "Boolean Parameter"
          - Name = SHOW
          - checkbox- for true

      - vi script.sh
        #!/bin/bash

        FIRST_NAME=$1
        LAST_NAME=$2
        SHOW=$3
        if [ "$SHOW" = "true" ]; then
          echo "Hello! $FIRST_NAME $LAST_NAME"
        else
        echo "error"
        fi

      - esc, :wq! , enter
      - ./script.sh
        - error
      - ./script.sh Nayan Rajani true
  
  - Copy the file in jenkins container
    - ctrl + r and type cp for this command -> (docker cp script.sh jenkins:/tmp/script.sh)
    - ctrl + r and type exec for this command -> (docker exec -it jenkins sh)
    - cat /tmp/script.sh
      - /tmp/script.sh Nayan Rajani true

      OR (Execute this in first job as well)

    - Build Environment
      - in the add build build setup section select  "Execute shell"
        - /tmp/script.sh $FIRST_NAME $LAST_NAME $SHOW
        - Save
      - Click build with parameter (Button change)
        - you can change the name it will pop-up
  
- NOTE:
  - So it remember that everything is being handled by the script.
  - The only one thing that Jenkins is doing is providing all is to populate these information.
  - And then based on the logic that we used here, Dan Jenkins is going to display whatever we want to be displayed.

## Section-4 Jenkins & Docker

### Docker + Jenkins + SSH - 1

- let's say you want to work on another host machine where you want to run some different task.
- so what we can do we can create one more container over here to do ssh and run some commands via ssh.
  - docker ps
  - create a folder to save files for this little project
    - Check Jenkins-resources/centos folder.
    - cd jenkins-data
      - mkdir centos7
      - cd centos7
      - ll
      - vi Dockerfile
        FROM centos:7

        RUN yum -y install openssh-server

        RUN useradd remote_user && \
            echo "remote_user:1234" | chpasswd && \
            mkdir /home/remote_user/.ssh && \
            chmod 700 /home/remote_user/.ssh

      - esc, :wq! , enter

    - Troubleshooting: remote-host image not building correctly?
      Hey, there!
      There's a chance that your remote-host image won't sucessfully build.
      Why?
      Well, in the course we are using centos:latest, which at that point was centos:7. In September/2019, centos 8 was released, and it's downloaded instead of the 7 version when you use "latest"
      Resolution:
      1 - Change the from instruction and point to centos 7
      FROM centos:7
      2- Keep using centos 8 and modify these lines:
      Change this

      RUN useradd remote_user && \
          echo "1234" | passwd remote_user  --stdin && \ # Passwd command is deprecated on centos:8
          mkdir /home/remote_user/.ssh && \
          chmod 700 /home/remote_user/.ssh

      to this:

      RUN useradd remote_user && \
          echo "remote_user:1234" | chpasswd && \
          mkdir /home/remote_user/.ssh && \
          chmod 700 /home/remote_user/.ssh

      You could also see errors related to sshd-keygen. If so, just change this line from :

      RUN /usr/sbin/sshd-keygen

      to

      RUN ssh-keygen -A

### Docker + Jenkins + SSH - 2

- Let's continue in the same file
- Now we need to create a ssh key or private key
  - ssh-keygen -f remote-key
  - enter, enter, enter
    - this will create two files a remote-key which is a certificate key/Private key
    - and the second will be the Public key which is in .pub extension
  - now let's modify the file again
    - vi Dockerfile
      FROM centos:7

      RUN yum -y install openssh-server

      RUN useradd remote_user && \
          echo "remote_user:1234" | chpasswd && \
          mkdir /home/remote_user/.ssh && \
          chmod 700 /home/remote_user/.ssh

      COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

      RUN chown remote_user:remote_user -R /home/remote_user/.ssh/ && \
          chmod 600 /home/remote_user/.ssh/authorized_keys

      RUN /usr/sbin/sshd-keygen

      CMD /usr/sbin/sshd -D

    - esc, :wq!, enter

### Docker + Jenkins + SSH - 3

- Now we will do some final configuration to spin up our ssh server.
- to configure we need to go back to docker-compose file, check Jenkins-resources/jenkins-jenkins.yml for remote_user
  - cd
  - cd jenkins-data/
  - ll
  - vi docker-compose.yml
    - add below code in older file
        remote_host:
          container_name: remote_host
          image: remote_host
          build:
            context: centos7
          networks:
            - net

    - Save it
    - docker-compose build
    - docker images
    - docker ps
    - docker-compose up -d

  - let's go to jenkins container
    - docker exec -it jenkins bash
    - ssh remote_user@remote_host
      - yes
      - add password 1234
      - exit
      - exit
    - cd centos7
    - ll
    - docker cp remote-key jenkins:/tmp/remote-key
    - docker exec -it jenkins bash
    - cd /tmp/
    - ls
    - ssh -i remote-key remote_user@remote_host
      - successfully logged in
      - exit
    - exit

- Install Plugins
  - cd jenkins-data
  - ping google.com (if successful then fine)
  - go to jenkins and login
  - go to manage jenkins -> plugins
  - go to available -> search for ssh [select this] -> select -> install without restart
  - after success -> checkbox the restart -> wait for it and check in installed section. (if not started again, please run docker-compose up -d)

- Integrate your Docker SSH server with Jenkins
  - manage jenkins -> under - manage security -> credentials
  - Stores scoped to Jenkins -> click on systems -> click on global credentials -> add global credentials
    - choose ssh username and private key-> add remote_user (we created a remote_user in dockerfile, cat centos7/Dockerfile) -> 
    - in VM -> cat centos7/remote-key -> copy the Key and paste it over there in a key section -> click create.
  - manage jenkins -> under manage jenkins ->  -> system
  - see ssh sites -> click on ADD
    - add hostname: remote_host
    - post: 22
    - now add credentials :remote_user
      - click check connection
      - if successful then click on save

- Run your a Jenkins job on your Docker remote host through SSH
  - in which container it will be created??? -> file will be created in remote-host
  - create a new item remote-project
    - freestyle project 
      - ok
      - go to build -> select Execute shell script on remote host using ssh
        - ssh site: already propogated
        - command: 
          - NAME=Nayan
            echo "Hello, $NAME. please see the current date and time $(date)" > /tmp/remote-file
      - save
    - build now
      - check console output
    - now check in container
    - cd jenkins-data
    - docker exec -it remote-host bash
    - cat /tmp/remote-file
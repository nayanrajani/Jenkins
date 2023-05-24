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
- If you lost you jenkins user
  - cd jenkins-data
    - cd jenkins_home
      - vi config.xml
        - change the below value
          - From:
            - <useSecurity>true</useSecurity>
          - To:
            - <useSecurity>false</useSecurity>
- Then login to jenkins and manage jenkins
  - Security
    - Security Realm
      - choose jenkins own user database
  - manage role and assign roles
    - manage roles
      - role to add
        - admin
          - administrator
    - assign roles
      - User/group to add
        - admin
    - checkbox above for administrator for admin.

## Section-2 Introduction & Installation

- <https://www.javatpoint.com/jenkins>

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
    - on login check with "hostname -I" and copy the IP

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
      - check <https://www.golinuxcloud.com/another-app-is-currently-holding-the-yum-lock/>
    - vi /etc/yum.conf
      - press insert from keyboard and add below configuration incide that file after this line "distroverpkg=centos-release"
        - #add timeout here
        - timeout=120
      - esc, :wq!, this will save the file
    - exit
  - Copy and paste the commands from link to VM.
  - Install using the rpm repository
    - sudo yum install -y yum-utils
    - sudo yum-config-manager --add-repo <https://download.docker.com/linux/centos/docker-ce.repo>
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
    - sudo curl -SL <https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64> -o /usr/local/bin/docker-compose
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

## Section-5-Jenkins&AWS

### MYSQL + AWS + SHELL SCRIPTING + JENKINS

- We are going to create a jenkins job that gonna take a mysql backup and it will be uploaded to s3.

### Create a Mysql server on DOCKER

- now let's go to jenkins-data

  - cd jenkins-data
  - ll
  - vi docker-compose.yml
    - add db server
      - check docker-compose.yml
      - save
  - docker-compose up -d
  - docker ps -a
  - docker logs -f db
    - if you see at bottom "mysql is ready"
  - docker exec -ti db bash
    - mysql -u root -p
    - enter password
      - show databases;
    - exit
  - exit
  - docker ps

### INSTALL MYSQL Client and AWS CLI

- we are going inside the remote-host that we created earlier.

  - docker exec -ti remote-host bash
  - mysql
    - you will get Error
  - exit
  - for this we need to modified the docker file, under centos7 directory
    - cd centos7/
    - vi Dockerfile
      - add data for mysql and awscli in Dockerfile
      - save
    - docker-compose build
    - docker images
    - cd ..
    - docker-compose up -d   //this will recreate the remote-host
    - docker exec -ti remote-host bash
      - mysql
      - aws
    - exit

### Create MYSQL Database

- cd jenkins-data
- cat docker-compose.yml
- docker exec -ti remote-host bash
  - login to mysqldb
  - mysql -u root -h db_host -p
    - Enter Password: 123456
  - now you are under the mysql server host
  - now create a database, run these below cmmand

    - create database testdb;
    - use testdb;
      - create table info (name varchar(20), lastname varchar(20), age int(2));
      - desc info;
      - insert into info values('Nayan', 'Rajani', '23');
      - insert into info values('Mayank', 'Chouhan', '57');
      - insert into info values('Bhajan', 'Vajan', '35');
      - select * from info;

### Create S3 Bucket on AWS

- login to your AWS Account and create a S3 Bucket
- jenkins-mysql-backup-training

## Create IAM User for Authentication

- create an IAM User with S3FullAccess.
- jenkins-mysql-backup
- Now create a Access key and secret Access key under security credentials. [Download the CSV File as well].

### Learn to take backup and upload to S3 Manually

- docker ps
- we are going to run this task on remote-host
- docker exec -ti remote-host bash
  - MYSQL
    - mysqldump -u root -h db_host -p testdb > /tmp/db.sql
      - Enter Password: 123456
    - cat /tmp/db.sql

  - AWS CLI
    - aws configure
      - AWS_ACCESS_KEY_ID= <your_Access_key>
      - AWS_SECRET_ACCESS_KEY= <your_Secret_key>
      - region=ap-south-1
      - Hit Enter

  - NOW UPLOAD
    - aws s3 cp /tmp/db.sql s3://jenkins-mysql-backup-training/db.sql

### Automate the backup and upload process with a shell script

- docker exec -ti remote-host bash
- vi /tmp/aws-s3.sh
  - check aws-s3.sh
    #/bin/bash

    DATE=$(date +%H-%M-%S)
    BACKUP=db-$DATE.sql

    DB_HOST=$1
    DB_PASSWORD=$2
    DB_NAME=$3

    mysqldump -u root -h $DB_HOST -p$DB_PASSWORD $DB_NAME > /tmp/$BACKUP

- chmod +x /tmp/aws-s3.sh
- /tmp/aws-s3.sh db_host 123456 testdb

### Integrate your script with AWS CLI

- create access key and secret key again if you have deleted.
- docker exec -ti remote-host bash
- vi /tmp/aws-s3.sh
  - to upload to s3-code check aws-s3.sh
  - copy and paste the content of that file
  - save it
- aws configure
  - AWS_ACCESS_KEY_ID= <your_Access_key>
  - AWS_SECRET_ACCESS_KEY= <your_Secret_key>
  - region=ap-south-1
  - Hit Enter
- /tmp/aws-s3.sh db_host 123456 testdb jenkins-mysql-backup-training

### Learn how to manage sensitive information in Jenkins (Keys, Passwords)

- Create two credntials [choose secret text] for AWS_SECRET_KEY and MYSQL_PASSWORD
  - ID - AWS_SECRET_KEY
  - Secret - <your_Secret_key>
  - ID - MYSQL_PASSWORD
  - Secret - <db_password>

### Create a Jenkins job to upload your DB to AWS

- in jenkins
  - new item
  - backup-to-aws
  - free-style-project
  - ok

- go to general section
  - this project is parameterized
  - string parameter
    - name: MYSQL_HOST
    - default value: db_host
  - string parameter
    - name: DATABASE_NAME
    - default value: testdb
  - string parameter
    - name: AWS_BUCKET_NAME
    - default value: jenkins-mysql-backup-training

- go to build enviornment section
  - select use secret text
  - add
    - secret text
      - variable: MYSQL_PASSWORD
      - credential: select mysql_secret
  - add
    - secret text
      - variable: AWS_SECRET_KEY
      - credential: select aws_secret

- For this execution on remote host by jenkins we need to create a new file check aws-s3-v1.sh
  - vi /tmp/aws-s3-v1.sh
    - to upload to s3-code check aws-s3-v1.sh
    - copy and paste the content of that file
    - save it
  - chmod +x /tmp/aws-s3-v1.sh

- go to Build Section
- jenkins again
  - add build step
    - execute shell script on remote host using ssh
      - ssh_site: slect remote-host
      - command: /tmp/aws-s3-v1.sh $MYSQL_HOST $MYSQL_PASSWORD $DATABASE_NAME $AWS_SECRET_KEY $AWS_BUCKET_NAME

- save
- build with parameter
- check console output

### Persist the script on the remote host

- docker ps -a
- let's say bychance you deleted the container by below command
  - docker kill [name-of-container] //Do not run this command

- and if you recreate at same level
  - docker-compose up -d
  - docker exec -ti remote-host bash
  - cat /tmp/aws-s3.sh
  - You will get nothing, files are deleted because of container deletion
  - exit

- NOW we are going to mount this files parmanently to the volumes.
- ll

- Modify the docker-compose.yml
  - check docker-compose1.yml //do not recreate, i have created for simplicity
  - just adding volumes will be fine in your original file in your VM.
  - save

- docker-compose up -d
- docker exec -ti remote-host bash
- /tmp/aws-s3.sh db_host 123456 testdb jenkins-mysql-backup-training
- run from jenkins as well.

### Reuse your Job to upload different DB's to different buckets

- now create a new database inside remote-host
- docker exec -ti remote-host bash
  - mysql -u root -h db_host -p
    - Enter Password: 123456
  - now you are under the mysql server host
  - now create a database, run these below cmmand

    - create database test2;
    - use test2;
      - create table info (name varchar(20), lastname varchar(20), age int(2));
      - desc info;
      - insert into info values('Nayan', 'Rajani', '23');
      - insert into info values('Mayank', 'Chouhan', '57');
      - insert into info values('Bhajan', 'Vajan', '35');
      - select * from info;

  - create one more bucket
    - test2-jenkins

- now go to jenkins and click on build with parameter
  - change the two paramer
    - database_name: test2
    - Bucket_name: test2-jenkins
- click on build, it should work.

## Section-6-Jenkins&Ansible

- <https://www.javatpoint.com/ansible>

### Ansible

- Ansible automates the management of remote systems and controls their desired state. A basic Ansible environment has three main components:

- Control node
  - A system on which Ansible is installed. You run Ansible commands such as ansible or ansible-inventory on a control node.

- Managed node
  - A remote system, or host, that Ansible controls.

- Inventory
  - A list of managed nodes that are logically organized. You create an inventory on the control node to describe host deployments to Ansible.

- ![image](https://github.com/nayanrajani/Jenkins-master/assets/57224583/c513c086-0117-4480-82c0-bcbd29a55419)

### Install Ansible in Docker + Jenkins

- go to cd jenkins-data/
  - mkdir jenkins-ansible
  - cd jenkins-ansible
  - we are going to create a image for that we need to create a Dockerfile here.
  - vi Dockerfile
    - check Dockerfile
  - cd ..
- now we need to modify docker-compose.yml
- vi docker-compose.yml
  - check docker-compose.yml
- docker-compose build
  - if you get error for code 100 and 127, please issue [here](https://github.com/nayanrajani/Jenkins-master/issues/1)
- docker-compose up -d
- docker ps -a
- docker exec -ti jenkins bash
  - ansible

### Make the ssh keys permanent on the Jenkins container

- we are going to use a private-key that we created in centos7 folder.
- we will now allow jenkins to use this keys as well.
- go to dcoker-compose.yml to look into it, how we are sharing file with columes
  - exit
- ls
- cd jenkins_home
  - you will see a bunch of files here
- docker exec -ti jenkins bash
  - cd $HOME
  - pwd
  - ls /var/jenkins_home/
    - you will see same bunch of files here from jenkins_home
  - touch nayan1234
  - ls /var/jenkins_home/
  - exit

- ll
- ll jenkins_home
- you will see our file is shared here as well
- in jenkins-data folder
  - mkdir jenkins_home/ansible
  - docker exec -ti jenkins bash
    - cd $HOME
    - ls ansible/
    - exit
- ls
- pwd
- cp centos7/remote-key jenkins_home/ansible/
- ls jenkins_home/ansible/
- docker exec -ti jenkins bash
  - cd $HOME
  - ls ansible/
  - exit

### Create a simple Ansible Inventory

- cd jenkins-data/
- docker ps -a
- cd jenkins-ansible
- cp ../centos7/remote-key .
- ll
  - Inventory is the file where you define all of your hosts
  - vi hosts
    - check hosts file
  - cp hosts ../jenkins_home/ansible/
  - docker exec -ti jenkins bash
    - cd $HOME
    - cd ansible/
    - ls
      - you will see the hosts file here
    - cat hosts
    - ping remote_host

    - Ping from ansible now
      - ansible -i hosts -m ping test1
      - if you get error
    - cd ..
    - ssh-keygen -f /var/jenkins_home/.ssh/known_hosts
    - ansible -i hosts -m ping test1

### Create your first Ansible Playbook

- playbook is a script, where we can define some commands or task that ansible will do.
- all the playbooks are written in yaml
- cd jenkins-data/jenkins-ansible
- we will create the file outside of container because we don't have vim and any editor inside the container for now.
- vi play.yml
  - check play.yml
- cp play.yml ../jenkins_home/ansible/

- docker exec -ti jenkins bash
  - cd $HOME
  - cd ansible
  - ls
    - you will be able to see the file here
  - ansible-playbook -i hosts play.yml
  - /tmp/ansible-file
    - you will get nothing
  - exit
- docker exec -ti remote-host bash
  - cat /tmp/ansible-file

### Integrate Ansible and Jenkins (Ansible Plugin)

- login to jenkins
- managed jenkins
- plugins -> available plugins -> search for Ansible
  - install without restart
  - restart
- go to installed plugins -> search and chek it.

### Learn how to execute Playbooks from a Jenkins Job

- go to cd jenkins-data
- docker exec -ti jenkins bash
  - cd
  -cd ansible
  - ls -l
  - pwd
    - copy below path
    - /var/jenkins_home/ansible

- login to jenkins
- new item
  - ansible-test
    - freestyle project
    - ok
  - build section
    - choose invoke ansible playbook
    - path for playbook: /var/jenkins_home/ansible/play.yml
    - inventory: file or host list -> /var/jenkins_home/ansible/hosts
  - save
- build now

- in VM
- exit
- vi jenkins_home/ansible/play.yml
  - update the file
  - save
- docker exec -ti jenkins bash
  - cd
  - cat ansible/play.yml
    - changes are here

- in jenkins
  - run again
  - and check console output
- build successfull

- in VM
- login to remote-host
  - docker exec -ti remote-host bash
  - cat /tmp/ansible-file

### Power up! Add parameters to Ansible and Jenkins

- we are going to use a parameter in jenkins and that parameter will get the file and edit the changes.

- in VM
- vi jenkins_home/ansible/play.yml
  - please check play1.yml because we are doing changes here.

- in jenkins
- configure for ansible-test
  - in general
    - choose this project is parameterised
      - add parameter
        - Name: ANSIBLE_MSG
        - default value: Hello World
  - build section
    - inside playbook configuration
      - advanced
        - Extra Variables button
          - key: MSG
          - value: $ANSIBLE_MSG

  - save

- build with parameters
  - modify the text
- build

- console output

### Missing the colors? Colorize your playbooks' output

- we need to install a plugin for colors
- in jenkins
  - managed jenkins -> plugins -> available
  - AnsiColor -> Install without restart -> wait for install and then restart
  - check if you want

- go to ansible-test
  - configure
  - build-environment
    - choose Color ANSI Console Output
      - default setting will be fine

  - build section
    - inside playbook configuration
      - advanced
        - choose Colorized Output

  - save

- build with parameters
  - modify the text
- build

- console output

### Challenge: Jenkins + Ansible + MySQL + PHP + NGINX + Shell Scripting

### Create the DB that will hold all the users

- go to db container
  - docker exec -ti db bash
  - mysql -u root -p
    - enter password
    - show databases;
    - create database people;
    - use people;
    - show databases;
    - create table register (id int(3), name varchar(50), lastname varchar(50), age int(3));
    - show tables;
    - desc register;

### Create a Bash Script to feed your DB - I

- cd jenkins-ansible
  - vi people.txt
    - check people.txt, it contains a lot of names
  - vi put.sh
    - check put1.sh //i have created only one file but here i'm showing two files for better understanding
  - nl people.txt  // to get all the line with specific number
    - with specific id
      - nl people.txt | grep -w 2
      - nl people.txt | grep -w 4
    - with column
      - nl people.txt | grep -w 2 | awk '{print $2}' //it will print cloumn 2

    - Spliting with -> awk -F ','
      - nl people.txt | grep -w 2 | awk '{print $2}' | awk -F ',' '{print $1}' //it will split cloumn 2 with comma and print name
      - nl people.txt | grep -w 2 | awk '{print $2}' | awk -F ',' '{print $2}' //it will split cloumn 2 with comma and print lastname
    - check put1.sh
  - chmod +x put.sh //executable permission
  - ./put.sh

### Create a Bash Script to feed your DB - II

- cd jenkins-ansible
  - shuf -i 20-25 -n 1 // this will print age like 21,22,23,24,25
  - vi put.sh
    - check put.sh

### Test your Script inserting the data to the DB

- cd jenkins-ansible
- ll
- chmod +x put.sh
- docker cp put.sh db:/tmp
- docker cp people.txt db:/tmp
- docker exec -ti db bash
  - cd /tmp/
  - ls -l
  - ./put.sh
  - mysql -u root -p
    - enter password
    - use people;
    - show databases;
    - show tables;
    - select * from register;

### Start building a Docker Nginx Web Server + PHP - I

- we are going to create a web server thet will hold a HTML to display a table.
- create a folder web under jenkins-ansible/
- mkdir jenkins-ansible/web
- cd jenkins-ansible/web
  - vi Dockerfile
    - check web folder, we are using FROM remote-host, it means it will create a image from remote-host and it will run all the commands from remote-host Dockerfile in Centos7
  - cat Dockerfile
  - now create folders like bin and conf, and create files under that same.
    - if you are using jenkins.local name as a localhost then modify below settings
      - for nginx.conf file, need to modify
        - open notepad with admnistrator
          - file -> open -> paste below address in file bar
            - C:\Windows\System32\drivers\etc
              - choose "all files" from bottom
            - select hosts
              - add below config at the bottom of file
                - [your-localIP] jenkins.local
              - save
  - paste the files and check.

### Start building a Docker Nginx Web Server + PHP - II

- cd ..
- cd..
- in jenins-data
  - vi docker-compose.yml
    - create a new service, check docker-compose.yml under web folder.
    - save
  - docker-compose build
  - docker-compose up -d
  - docker ps -a
    - go to web and search for [your-localip]:80 and you will see an nginx error 403, it means nginx is installed

  - docker exec -ti web bash
    - cd /var/www/html/
      - vi index.php
        - check index.php under web folder
        - add data
        - save
        - now refresh the web page

### Build a table using HTML, CSS and PHP to display users

- cd jenkins-ansible
  - vi table.j2
    - check table.j2 inside web folder
    - save
  - now we need to copy and paste this file to our web-> html folder -> index.php, it will replace the file with index.php to table.j2
  - docker cp table.j2 web:/var/www/html/index.php
  - check output on web [your-localip]:80

### Integrate your Docker Web Server to the Ansible Inventory

- our inventory is created under jenkins_home/ansible
- we need to modify the hosts file here, and adding web here as we added test1
- in jenkins-data/
  - vi jenkins_home/ansible/hosts
    - check hosts file in web folder
- in jenkins bash
  - docker exec -ti jenkins bash
    - ssh web
      - yes
      - ctrl + C
    - cd
    - cd ansible/
    - ls
    - cat hosts
    - ansible -m ping -i hosts web1
      - success
    - ansible -m ping -i hosts test1
      - success
    - ansible -m ping -i hosts all

### Create a Playbook in Ansible to update your web table

- in jenkins-data
- we are creating a ansible playbook
  - vi jenkins_home/ansible/people.yml
    - check people.yaml in web folder
    - save

- in jenkins-ansible
  - ll
  - vi table.j2
    - check table1.j2, this i have created for change reference
    - save
  - cp table.j2 ../jenkins_home/ansible

### Test your playbook and see the magic

- in jenkins-ansible
  - docker exec -ti web bash
    - cd
    - cd /var/www/
    - ll
    - chown remote_user:remote_user /var/www/html/ -R
    - ll
  - docker exec -ti jenkins bash
    - cd
    - cd ansible/
    - ls
      - you will see the file people.yml and table.j2
    - Without Age declaration:
      - ansible-playbook -i hosts people.yml
      - check web [your-localip]:80, you will see all the data

    - With Age declaration:
      - ansible-playbook -i hosts people.yml -e "PEOPLE_AGE=22"
      - check web [your-localip]:80, you will see all the data

### Ready? Let's create a Jenkins Job to build everything with a click

- new item
  - ansible-users-db
  - freestyle project
  - ok
    - in general
      - choose this project is parameterised
        - choose choice parameter
          - name: AGE
          - choice: 20
                    21
                    22
                    23
                    24
                    25
    - in build environment
      - choose color Ansi Console Output
        - default

    - in build
      - choose invoke ansible playbook
        - playbook path: /var/jenkins_home/ansible/people.yml
        - inventory: file or host: /var/jenkins_home/ansible/hosts

      - Advanced
        - choose Colorized stdout
        - choose extra variable
          - key: PEOPLE_AGE
          - value: $AGE

    - Save
    - build with parameter
    - console output
    - check web [your-localip]:80, you will see all the data

## Section-7-Jenkins&Security

### Allow users to sign up

- under manage jenkins
  - security -> Authentication
    - choose "Allow users to sign up"
  - save
  - open incognito and chek by doing a signup
- roll-back to the older settings

### Install a powerful security plugin

- go to plugins -> install -> Role-based Authorization
- after restart
- under manage jenkins
  - security -> Authentication
    - choose "Role based Strategy"
  - save
- check we got a new section named as "Manage and Assign Roles"

- manage jenkins
  - go to Security -> Users -> you will see the new user
    - create a user and login in incognito
      - you will not be able to signin
      - because of the new plugin.

### Ever heard about roles? Let's create a Read Only role | Assign the role that you created to a particular user

- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
    - create a role
      - Admin/read-only/specific permission
      - add
        - checkbox for overall read-only and job read-only
      - save
    - Assign Role
      - User/group to add
        - type the name
          - nayan  [in my case]
            - add
      - now checkbox above table for nayan for read-only access
    - save
  - login to nayan user on incognito mode.

### Create a role to execute jobs, and assign that role to your user

- only for execution
- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
    - create a role
      - Execution-Role
      - add
        - checkbox for overall read-only and job read-only, build
      - save
    - Assign Role
      - now checkbox above table for nayan for read-only access and execution role
    - save
  - login to nayan user on incognito mode.

### Learn how to restrict Jobs to users using Project Roles

- we need to create a project role it is based on patterns to assign users in it.
- go to "Manage and Assign Roles"
  - Manage roles
    - Global Roles
      - create a role
        - Dev-Team
      - add
      - checkbox for overall read-only and job read-only
    - Project Roles
      - Role to add: Ansible
      - Pattern: ansible-.*
    - add
      - now you can mark checkbox for the resources to be allowed
    - save
  - assign roles
    - global roles
      - checkbox for Dev-Team for nayan user and remove execution role and read-only role
    - item roles
      - type nayan to add
        - checkbox for Ansible

## Section-8-Jenkins-tips&tricks

### Jenkins Environment Variable

- Chek on Google and create a job named as ENV or whatever name you wantand execute all the variables in execute shell section under build.

### Create your own custom global environment variables

- go to jenkins web
- manage jenkins
  - System
    - Global properties
      - checkbox Environment Variable
        - add many as you want
    - save

- under ENV job
  - configure
    - under shell execution
      - Global Variable
        - echo "Build Number is $BUILD_NUMBER"
        - echo "Build is $BUILD_ID"
      - Custom Variable
        - echo "This Course name is $NAME_OF_THE_COURSE"
        - echo "This Course Created in $COUNTRY

### Meet the Jenkins' cron: Learn how to execute Jobs automatically

- let's create a cron job like a scheduler.
- Go to ENV job
  - configure
    - under build trigger
      - select Build Periodically
        - a cron job here, check the given [link](https://crontab.guru/)
        - H 17 ** * (5'o clock)
        - H **** (every single Hour)
    - check in Build History, job will run every minute
    - revert the changes

### Download this plugin

- Install a plugin named Strict Crumb Issue
- Go to Manage Jenkins -> Configure Global Security -> CSRF Protection.
- Select Strict Crumb Issuer.
- Click on Advanced.
- Uncheck the Check the session ID box.
- Save it.

### Learn how to trigger Jobs from external sources: Create a generic user

- create a user and asign the execution role to it
- login with that user

### Trigger your Jobs from Bash Scripts (No parameters)

- in vm
- cd jenkins-data
  - curl 192.168.1.9:8080
  - crumb=$(curl -u "trigger:123456" -s '<http://192.168.1.9:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)>')
  - echo $crumb
  - create a crumbwithoutparameter.sh file
    - check in crumbwithoutparameter.sh
  - chmod +x crumbwithoutparameter.sh
  - ./crumbwithoutparameter.sh

### Trigger your Jobs from Bash Scripts (With Parameters)

- in vm
- cd jenkins-data
  - systemctl start ntpd
  - systemctl enable ntpd
  - create a crumbwithparameter.sh file
    - check in crumbwithparameter.sh
  - chmod +x crumbwithparameter.sh
  - ./crumbwithparameter.sh

## Section-9-Jenkins&Email

### Install Mail Plugin

- mailer (already installed)

### Integrate Jenkins and AWS Simple Email Service

- login to AWS
  - SES
    - create identity with email
      - verify it on your email

- In jenkins
  - manage jenkins
    - go to system
      - Jenkins Location
        - System Admin e-mail address
          - add your email address

      - E-mail Notification (scroll to bottom and click on advance as well)
        - SMTP server: email-smtp.ap-south-1.amazonaws.com (you will get this on AWS under SES under SMTP setting)
        - Default user e-mail suffix: [blank]
        - checkbox use SMTP Authentication
          - for this:
            - (you will get this on AWS under SES under SMTP setting and create SMTP credentials, then give it a name)
            - create and download it and paste it below accordingly
          - User Name: Copy and paste it
          - Password: Copy and paste it
          - choose checkbox for Use SSL
          - SMTP Port: Copy and paste it from SMTP settings page[TLS Wrapper Port], i have used 465
          - Reply-To Address: add email address again
        - Test configuration by sending test e-mail
          - Test e-mail recipient: type email ther if it doesn't pop up
          - test configuration

### Integrate Jenkins and Gmail [alternate to AWS]

- search on google for smtp google
- User Name: Email
- Password: GMail Password
- choose checkbox for Use SSL
- SMTP Port: Copy and paste it from google
- Reply-To Address: add email address again

- Enable the less secure apps on google
- test configuration by sending test e-mail

### Add notifications to your jobs

- go to jenkins
  - go to ENV Job
    - configure
      - Post build Action
        - add
          - EMail notfication
            - Recipients: type your email here
            - choose both option
      - build
        - type and do a mistake to check
    - Save
  - build now
    - it will fail wait for the notification on your mailer
  - revert the mistake
  - build now
    - check the mail again.

## Introduction: Jenkins & Maven

- <https://www.javatpoint.com/maven-tutorial>

### Install Plugin

- Maven Integration and chek in installed plugin is git is installer or not

### Learn how to clone a GIT/GITHUB repository from Jenkins

- google-> sample maven app

- copy the URL (<https://github.com/jenkins-docs/simple-java-maven-app.git>)

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

## Jenkins&Git

### Create a Git Server using Docker

- check git server requirement on google

- in virtualbox close + shutdown, and got to settings, system change ram to 4 gb recommended in 8 gb
- processor to 2
- ok

- start again virtual machine
- in VIM
  - cd jenkins-data
    - cat /proc/cpuinfo | grep cores
    - free -h
  - we will create a gitlab server with docker file
    - check docker-compose.yml
    - docker-compose up -d
    - docker ps -a
    - docker logs -f git-server
      - it is still executing wait till it completes
      - when you see chef client finished, it means it is completed
      - check on your browser with [yourip]:8090
        - we are not using DNS, if you are like we did in jenkins.local, you can do it here as well
        - Username: root
        - Password: Password stored to /etc/gitlab/initial_root_password. This file will be cleaned up in first reconfigure run after 24 hours
        - docker exec -ti git-server bash
        - cd
        - cat /etc/gitlab/initial_root_password
          - WARNING: This value is valid only in the following conditions
            - If provided manually (either via `GITLAB_ROOT_PASSWORD` environment variable or via `gitlab_rails['initial_root_password']` setting in `gitlab.rb`, it was provided before database was seeded for the first time (usually, the first reconfigure run).
            - Password hasn't been changed manually, either via UI or via command line.
              - If the password shown here doesn't work, you must reset the admin password following <https://docs.gitlab.com/ee/security/reset_user_password.html#reset-your-root-password>.

              - Password: [secret password]

            - NOTE: This file will be automatically deleted in the first reconfigure run after 24 hours.
        - Copy the password and login to the web gitlab server
        - change the password once you loggedin with that password

### Create your first Git Repository

- In Gitlab
- create a group
  - group name: jenkins
  - visibility level: Private
  - create new project
    - maven
    - private
    - create

### Create a Git User to interact with your Repository

- go to settings
- create a new user, with access level of regular then create
  - now edit that user to add password
- now login with this user and change the password

- now go to projects -> maven project -> manage access -> invite mmebers -> type username, role will be maintainer, invite

### Upload the code for the Java App in your Repo

- <https://github.com/jenkins-docs/simple-java-maven-app>
- go to your vm
  - cd jenkins-data
    - sudo yum -y install git
      - password
    - git clone <https://github.com/jenkins-docs/simple-java-maven-app>
    - ls -l
    - now we need to upload this code to gitlab server
      - in gitlab
        - under maven project
          - repository
            - files
              - copy the command from add your files for cloning
                - git clone <http://gitlab.nayan.com/jenkins/maven.git>
                  - it will give you an error, because we haven'r set the gitlab.nayan.com.
                    - we will use
                      - git clone <http://192.168.1.8:8080/jenkins/maven.git>
                        - enter name
                        - enter password
                      - cd maven
                        - cp -r ../simple-java-maven-app/* .
                        - git status
                        - git add .
                        - git commit -m "adding maven files"
                        - git push origin main
                    - refresh your browser page of maven project

### Integrate your Git server to your maven Job

- Now we will integrate this to our jenkins maven job, so that we can retrieve the code directly from our gitlab rather then github.

- login to jenkins
  - first need to create user because our current repo has credentials to pull, push code
    - manage jenkins
      - security
      - credentials
        - system (Stores scoped to Jenkins)
          - global credentials
            - add credentials
              - username with password
                - username: [yourusername]
                - username: [yourpassword]
                - ID: git_maintainer
              - create
  - go to maven-job
    - configure
      - under SCM (because we are now doing internal communication so we need to use port 80)
        - Repo URL: <http://git:80/jenkins/maven.git>
        - credentials: choose git_maintainer
      - save
      - build now
      - console output

### Learn about Git Hooks & Trigger your Jenkins job using a Git Hook

- Git hooks is like a trigger, whenever someone pushes to any branch, and then a trigger is going to happen where you can define what you want to do.
- in VM
  - cd jenkins-data
    - docker exec -ti git-server bash
      - we need to search for a hashed repo, for that
        - To look up a project’s hash path in the Admin Area:

        - On the top bar, select Main menu > Admin.
        - On the left sidebar, select Overview > Projects and select the project.
        - The Gitaly relative path is displayed there and looks similar to:

          - "@hashed/b1/7e/b17ef6d19c7a5b1ee83b907c595526dcb1eb06db8227d650d5dda0a9f4ce8cd9.git"

      - now in container
        - cd /var/opt/gitlab/git-data/repositories/[@hashed-path]
        - ls -l
        - mkdir custom_hooks
        - cd custom_hooks
          - vi post-receive
            - check post-receive
            - save
          - chmod +x post-receive
          - cd ..
        - ll
        - chown git:git custom_hooks/ -R  (changing permission)
        - ll
        - exit

  - cd maven/
    - ll
    - grep -R Hello
      - copy the hello world java app path
      - copy the test code path
    - vi src/main/java/com/mycompany/app/App.java
      - change anything in Hello world section
    - vi src/test/java/com/mycompany/app/AppTest.java
      - change something in assert line
    - git status
    - git add .
    - git commit -m "adding maven updated files"
    - git push origin main

## Introduction: Jenkins DSL

- <https://www.jenkins.io/doc/pipeline/steps/job-dsl/>
- <https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-job-configuration-using-job-dsl>
- <https://github.com/jenkinsci/job-dsl-plugin/wiki/Tutorial---Using-the-Jenkins-Job-DSL>
- <https://jenkinsci.github.io/job-dsl-plugin/>

### Install Plugin

- Job DSL in jenkins

### Create a Parent Seed

- in jenkins
  - Create a new item -> job-dsl-master -> fressstyle -> ok
    - in Configure
      - Build
        - Add a build step -> choose Process Job DSLs
          - choose Use the provided DSL script
            - check under dsl -> job.j2
            - copy the code and paste in the DSL Script section
    - save
      - managejenkins
        - Security -> in process script approval, approve manually
    - build now
    - check configure

- now check the child job is created on dashboard but do not run this

### Description

- you can directly add a description or you can write a code for that too.
  - check description.j2
  - paste this code there on jenkins and re run
  - now check the child job is created on dashboard but do not run this

### Parameters

- check parameters.j2
- copy the code and paste it in job-dsl-master and build the master one
- now check the child job is created on dashboard but do not run this

### SCM [Source Code Management]

- check scm.j2
- paste this code there on jenkins job "job-dsl-master" and re run and check child1 job

### Triggers

- check triggers.j2
- paste this code there on jenkins job "job-dsl-master" and re run and check child1 job

### Steps

- check steps.j2
- paste this code there on jenkins job "job-dsl-master" and re run and check child1 job

### Mailer

- check mailer.j2
- paste this code there on jenkins job "job-dsl-master" and re run and check child1 job

### Recreate the Ansible Job using DSL

- check ansible.j2
- paste this code after the older job(if you want to keep the older job) and then on jenkins job "job-dsl-master" and re run and check dsl-ansible job

- in VM
- cd jenkins-ansible
  - docker exec -ti web bash
    - cd
    - cd /var/www/
    - ll
    - chown remote_user:remote_user /var/www/html/ -R
    - ll

- in jenkins
  - Build with parameters the newly created dsl-ansible job
  - check on web with [your-ip]:80

### Recreate the Maven Job using DSL

- check maven.j2
- paste this code after the older job(if you want to keep the older job) then on jenkins job "job-dsl-master" and re run and check dsl-maven job

### Version your DSL code using Git

- on git web server
- create a new project under jenkins group
  - name: dsl-jenkins-jobs
  - create
  - Project Information
    - members
      - invite the member maintain

- in VM
- cd jenkins-data
  - ll
  - git clone <http://192.168.1.6:8090/jenkins/dsl-jenkins-jobs.git>
    - username and password of maintain
  - cd dsl-jenkins-jobs
    - vi jobs
      - go to jenkins dashboard and copy the DSL Script from "job-dsl-master"
      - paste the code here
    - save
    - git status
    - git add .
    - git commit -m "add dsl script to re-run from git server"
    - git push origin main

### Magic? Create Jobs only pushing the DSL code to your Git server

- cd dsl-jenkins-jobs
  - docker exec -ti git-server bash
    - cd
    - on jenkins
      - we need to search for a hashed repo, for that
        - To look up a project’s hash path in the Admin Area:

        - On the top bar, select Main menu > Admin.
        - On the left sidebar, select Overview > Projects and select the project.
        - The Gitaly relative path is displayed there and looks similar to:

          - "@hashed/4e/07/4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce.git"

      - now in container
        - cd /var/opt/gitlab/git-data/repositories/[@hashed-path]
        - ls -l
        - mkdir custom_hooks
        - cd custom_hooks
          - vi post-receive
            - check post-receive file
            - save
          - chmod +x post-receive
          - cd ..
        - ll
        - chown git:git custom_hooks/ -R  (changing permission)
        - ll
        - exit

- in Jenkins
  - in job-dsl-master
    - configure
      - SCM
        - choose GIT
          - Repo URL: <http://git:80/jenkins/dsl-jenkins-jobs.git>
          - Credential: Choose maintain credentials
      - Build
        - Process Job DSL
          - choose Look on Filesystem
            - jobs
    - Save
  
  - Manage Jenkins
    - Security -> security
      - Git plugin notifyCommit access tokens
        - uncheck Git plugin notifyCommit access tokens
    - Save
  
  - cd jenkins-data
    - cd dsl-jenkins-jobs
      - vi jobs
        - change anything that you want to reflect the change live
      - save
      - git status
      - git diff jobs
      - git add .
      - git commit -m "Creating a new job via GIT SERVER"
      - git push origin main

- now in jenkins check a new execution in job-dsl-master, and check on dashboard new jobs are created.

## Introduction - CI/CD

- https://www.javatpoint.com/devops-pipeline-and-methodology
- https://www.guru99.com/ci-cd-pipeline.html

- CI/CD is nothing else but a methodology/strategy to deploy code faster to production!

- Thinks that you have an app and you want to deploy it to prod. What should you do? Well you should do a lot manual things, like testing it yourself, compiling, deploying, etc. All of this is normally done manually by a human who can make mistakes! And probably that guy will be awake at 2 am deploying to prod. Trust me, I've lived it.

- So, how does CI/CD help?

- Well, you will define an entire workflow that will build, test and deploy automatically for you! Isn't cool?

- The process is defined by some steps, starting at CI which is Continuous Integration, where you build an test your code; optionally, you could pass to Continuous Delivery, which deploys your built and tested app to a dev/stg/qa env (just to test again) and finally you deploy to production!

- You can read this great article to go deeper: https://www.infoworld.com/article/3271126/ci-cd/what-is-cicd-continuous-integration-and-continuous-delivery-explained.html

### What is Continuous Integration, Continuous Delivery, and Continuous Deployment?

- Continuous integration is a software development method where members of the team can integrate their work at least once a day. In this method, every integration is checked by an automated build to search the error.

- Continuous delivery is a software engineering method in which a team develops software products in a short cycle. It ensures that software can be easily released at any time.

- Continuous deployment is a software engineering process in which product functionalities are delivered using automatic deployment. It helps testers to validate whether the codebase changes are correct, and it is stable or not.

- ![MicrosoftTeams-image (1)](https://github.com/nayanrajani/Personal/assets/57224583/5012de1f-001a-474b-9751-be7eb712cde9)

## Introduction to jenkins pipeline

- https://www.jenkins.io/doc/book/pipeline/

- ![image](https://github.com/nayanrajani/Terraform/assets/57224583/1a86fc3c-a472-4676-a9da-7fe8fd747717)

- there are two types of pipelines
  - Declarative (super good for beginner)
  - Scripted (more complicated)

### Install the Jenkins Pipeline Plugin

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
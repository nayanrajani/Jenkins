# Section-5-Jenkins&AWS

## MYSQL + AWS + SHELL SCRIPTING + JENKINS

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
- vi /tmp/aws-s3.sh/aws-s3.sh
  - check aws-s3.sh
    #/bin/bash

    DATE=$(date +%H-%M-%S)
    BACKUP=db-$DATE.sql

    DB_HOST=$1
    DB_PASSWORD=$2
    DB_NAME=$3

    mysqldump -u root -h $DB_HOST -p$DB_PASSWORD $DB_NAME > /tmp/$BACKUP

- chmod +x /tmp/aws-s3.sh/aws-s3.sh
- /tmp/aws-s3.sh/aws-s3.sh db_host 123456 testdb

### Integrate your script with AWS CLI

- create access key and secret key again if you have deleted.
- docker exec -ti remote-host bash
- vi /tmp/aws-s3.sh/aws-s3.sh
  - to upload to s3-code check aws-s3.sh
  - copy and paste the content of that file
  - save it
- aws configure
  - AWS_ACCESS_KEY_ID= <your_Access_key>
  - AWS_SECRET_ACCESS_KEY= <your_Secret_key>
  - region=ap-south-1
  - Hit Enter
- /tmp/aws-s3.sh/aws-s3.sh db_host 123456 testdb jenkins-mysql-backup-training

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
  - vi /tmp/aws-s3.sh/aws-s3-v1.sh
    - to upload to s3-code check aws-s3-v1.sh
    - copy and paste the content of that file
    - save it
  - chmod +x /tmp/aws-s3.sh/aws-s3-v1.sh

- go to Build Section
- jenkins again
  - add build step
    - execute shell script on remote host using ssh
      - ssh_site: slect remote-host
      - command: /tmp/aws-s3.sh/aws-s3-v1.sh $MYSQL_HOST $MYSQL_PASSWORD $DATABASE_NAME $AWS_SECRET_KEY $AWS_BUCKET_NAME

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
  - cat /tmp/aws-s3.sh/aws-s3.sh
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
- /tmp/aws-s3.sh/aws-s3.sh db_host 123456 testdb jenkins-mysql-backup-training
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

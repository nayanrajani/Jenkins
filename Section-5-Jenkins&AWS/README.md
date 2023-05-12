# Section-5-Jenkins&AWS

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
- to upload to s3-code check aws-s3.sh
  - copy and paste the content of that file
- vi /tmp/aws-s3.sh
  - save it
- aws configure
  - AWS_ACCESS_KEY_ID= <your_Access_key>
  - AWS_SECRET_ACCESS_KEY= <your_Secret_key>
  - region=ap-south-1
  - Hit Enter
- /tmp/aws-s3.sh db_host 123456 testdb jenkins-mysql-backup-training
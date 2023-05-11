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
      - AWS_ACCESS_KEY_ID= AKIA5FOTFZWZEZQZFS5K
      - AWS_SECRET_ACCESS_KEY= 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
      - region=ap-south-1

  - NOW UPLOAD
    - aws s3 cp /tmp/db.sql s3://jenkins-mysql-backup-training/db.sql
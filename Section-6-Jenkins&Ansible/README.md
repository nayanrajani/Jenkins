# Section-6-Jenkins&Ansible

## Ansible

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

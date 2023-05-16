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
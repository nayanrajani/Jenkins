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
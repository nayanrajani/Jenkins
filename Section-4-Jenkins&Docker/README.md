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
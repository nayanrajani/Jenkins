# Jenkins&Git

## Create a Git Server using Docker

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
              - If the password shown here doesn't work, you must reset the admin password following https://docs.gitlab.com/ee/security/reset_user_password.html#reset-your-root-password.

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

- https://github.com/jenkins-docs/simple-java-maven-app
- go to your vm
  - cd jenkins-data
    - sudo yum -y install git
      - password
    - git clone https://github.com/jenkins-docs/simple-java-maven-app
    - ls -l
    - now we need to upload this code to gitlab server
      - in gitlab
        - under maven project
          - repository
            - files
              - copy the command from add your files for cloning
                - git clone http://gitlab.nayan.com/jenkins/maven.git
                  - it will give you an error, because we haven'r set the gitlab.nayan.com.
                    - we will use
                      - git clone http://192.168.1.8:8080/jenkins/maven.git
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
        - Repo URL: http://git:80/jenkins/maven.git
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
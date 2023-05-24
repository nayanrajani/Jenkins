# Introduction: Jenkins DSL

- <https://www.jenkins.io/doc/pipeline/steps/job-dsl/>
- <https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-job-configuration-using-job-dsl>
- <https://github.com/jenkinsci/job-dsl-plugin/wiki/Tutorial---Using-the-Jenkins-Job-DSL>
- <https://jenkinsci.github.io/job-dsl-plugin/>

## Install Plugin

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
  - git clone http://192.168.1.6:8090/jenkins/dsl-jenkins-jobs.git
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
          - Repo URL: http://git:80/jenkins/dsl-jenkins-jobs.git
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
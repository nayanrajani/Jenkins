# Section-8-Jenkins-tips&tricks

## Jenkins Environment Variable

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
        - H 17 * * * (5'o clock)
        - H * * * * (every single Hour)
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
  - crumb=$(curl -u "trigger:123456" -s 'http://192.168.1.9:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
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
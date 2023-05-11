## Section-3 Getting Started with Jenkins

### Intro to Jenkins UI

- power up system and jenkins again
  - cd jenkins-data
  - docker-compose up -d

- Hands On! Create first Jenkins Job [A Task in Jenkins called a Job]
  - create new item
  - give name "my-first-job"
  - free-style projects
    - Build Environment
      - in the add build build setup section select  "Execute shell"
        - Echo Hello World!
      - Save
    - Click build now
    - go to build history and chek your console output

- Let's play with our first job
  - again go to configure and under build step section, print date with string
    - echo "current date is $(date)"   //whoami,
    - repeat the steps for save and build and console output

- redirect output of first job
  - again in shell,
    - NAME=Nayan
    - echo "Hello $NAME. The current date and Time is $(date)"

  - to redirect in a file
    - NAME=Nayan
    - echo "Hello $NAME. The current date and Time is $(date)" > /temp/info
    - cat /temp/info

- Learn how to execute a bash script from Jenkins
  - let's create a script in VM machine outside of service container ($1 and $2 are parameters we will provide)
    - vi script.sh
      #!/bin/bash
      Name=$1
      LastName=$2

      echo "Hello! $Name $LastName"

    - esc, :wq! , enter
    - chmod +x ./script.sh
    - ./script.sh Nayan Rajani
  
  - COpy the file in jenkins container
    - docker cp script.sh jenkins:/tmp/script.sh
    - docker exec -it jenkins sh
    - cat /tmp/script.sh
      - /tmp/script.sh Nayan Rajani

      OR (Execute this in first job as well)

      - Name=Nayan
      - LastName=Rajani
      - /tmp/script.sh $Name $LastName

- Add Parameters to your Job
  - General
    - Select "This project is paramiterised"
      - Select "String Parameter"
        - Name = FIRST_NAME
        - Default Value = Nayan
      - Select "String Parameter"
        - Name = LAST_NAME
        - Default Value = Rajani
  - Build Environment
    - in the add build build setup section select  "Execute shell"
      - echo "Hello, $FIRST_NAME $LAST_NAME"
      - Save
    - Click build with parameter (Button change)
      - you can change the name it will pop-up

- How to create a List parameter
  - General
    - Select "This project is paramiterised"
      - Select "Choice Parameter"
        - Name = LASTNAME
        - choices = Rajani
                    rajani
                    Rajaani
  - Build Environment
    - in the add build build setup section select  "Execute shell"
      - echo "Hello, $FIRST_NAME $LAST_NAME"
      - Save
    - Click build with parameter (Button change)
      - you can change the name it will pop-up
    - remove this

- Add Basic Logic in Boolean Parameter
  - on the basis of true and false you will print the value from the script.sh
    - General
      - Select "This project is paramiterised"
        - Select "Boolean Parameter"
          - Name = SHOW
          - checkbox- for true

      - vi script.sh
        #!/bin/bash

        FIRST_NAME=$1
        LAST_NAME=$2
        SHOW=$3
        if [ "$SHOW" = "true" ]; then
          echo "Hello! $FIRST_NAME $LAST_NAME"
        else
        echo "error"
        fi

      - esc, :wq! , enter
      - ./script.sh
        - error
      - ./script.sh Nayan Rajani true
  
  - Copy the file in jenkins container
    - ctrl + r and type cp for this command -> (docker cp script.sh jenkins:/tmp/script.sh)
    - ctrl + r and type exec for this command -> (docker exec -it jenkins sh)
    - cat /tmp/script.sh
      - /tmp/script.sh Nayan Rajani true

      OR (Execute this in first job as well)

    - Build Environment
      - in the add build build setup section select  "Execute shell"
        - /tmp/script.sh $FIRST_NAME $LAST_NAME $SHOW
        - Save
      - Click build with parameter (Button change)
        - you can change the name it will pop-up
  
- NOTE:
  - So it remember that everything is being handled by the script.
  - The only one thing that Jenkins is doing is providing Ballis to populate these information.
  - And then based on the logic that we used here, Dan Jenkins is going to display whatever we want to be displayed.
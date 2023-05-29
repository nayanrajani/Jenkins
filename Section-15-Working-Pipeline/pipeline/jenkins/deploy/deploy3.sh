#!/bin/bash

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

#Transfer a file
scp -i /opt/prod /tmp/.auth prod-user@13.233.88.76:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish prod-user@13.233.88.76:/tmp/publish
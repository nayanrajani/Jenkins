#!/bin/bash

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

#Transfer a file
scp -i /opt/prod /tmp/.auth prod-user@{your-ec2-public-ip}:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish prod-user@{your-ec2-public-ip}:/tmp/publish
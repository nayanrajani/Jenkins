#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="maven-project"

echo "** Logging in ***"
docker login -u {docker-username} -p $PASS
echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG {docker-username}/$IMAGE:$BUILD_TAG
echo "*** Pushing image ***"
docker push {docker-username}/$IMAGE:$BUILD_TAG

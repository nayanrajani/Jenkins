FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install -y iputils-ping

RUN apt-get update && apt-get -y install ansible

USER jenkins
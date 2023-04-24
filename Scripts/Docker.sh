#!/bin/bash
# Created by rhvall
# Apr 2023
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License. 

## Get the ubuntu image
docker pull docker.io/library/ubuntu

## Run the container in detached mode
#PODID=$(docker run -dt --name mdc docker.io/library/ubuntu)
PODID=$(docker run -idt --rm --name mdc -p 20188:20188 mina-developer-container)
docker attach $PODID

## Stop container, if "--rm", it will remove it
docker stop $PODID

## List created and running containers
docker ps -a

## List images
docker image list -a

## Remove image
docker image rm mina-developer-container

## Create the container using "Containerfile" and the name "mina-developer-container"
docker build -t mina-developer-container -f Containerfile .

## Get the last image ID from docker
LAST=$(docker image ls | awk '{print $3}' | sed -n '2p')

## Remove the last image ID 
docker image rm $(docker image ls | awk '{print $3}' | sed -n '2p')

## Retrieve Container IP
PODIP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $PODID)

## SSH into container
ssh -v -i .ssh/idkey root@localhost -p 20188
ssh -v sshuser@localhost -p 20188

docker exec -it mdc /bin/bash

docker run -d --rm --name=agent --publish 2200:22 -e "JENKINS_AGENT_SSH_PUBKEY=.ssh/idkey.pub" jenkins/ssh-agent

docker image rm $(docker image ls | awk '{print $3}' | sed -n '2p') && docker build -t mina-developer-container -f Containerfile .
PODID=$(docker run -idt --rm --name mdc -p 20188:20188 mina-developer-container) && sleep 2 && docker ps -a 
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
#PODID=$(docker run -idt --rm --name mdc docker.io/library/ubuntu:20.04)
#PODID=$(docker run -idt --rm --name mdc gcr.io/o1labs-192920/mina-daemon:2.0.0rampup2-42d2005-bullseye-berkeley)
## If you need to specify a specific folder within the local environment, use "-v"
# PODID=$(docker run -idt --rm --name mdc -p 20188:20188 -v ./zkApp:/zkApp mina-developer-container)
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

## Execute a bash session within the mdc running container
docker exec -it mdc /bin/bash

## Remove the last image and build it again
docker image rm $(docker image ls | awk '{print $3}' | sed -n '2p') && docker build -t mina-developer-container -f Containerfile .
PODID=$(docker run -idt --rm --name mdc -p 20188:20188 mina-developer-container) && sleep 2 && docker ps -a 
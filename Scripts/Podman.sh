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

### Mac only
## -- Start
podman machine init
podman machine start
## -- End

## Get the ubuntu image
podman pull docker.io/library/ubuntu

## Run the container in detached mode
#PODID=$(podman run -dt --name mdc docker.io/library/ubuntu)
PODID=$(podman run -idt --rm --name mdc -p 20188:20188 localhost/mina-developer-container)
PODID=$(podman run -idt --rm --cap-add CAP_AUDIT_WRITE --name ss -p 20188:20188 localhost/sshi)
podman attach $PODID

## List created and running containers
podman ps -a

## List images
podman image list -a

## Remove image
podman image rm localhost/mina-developer-container

## Create the container using "Containerfile" and the name "mina-developer-container"
podman build -t mina-developer-container -f Containerfile
podman build -t sshi --cap-add=CAP_AUDIT_WRITE -f SSHCont

## Get the last image ID from podman
LAST=$(podman image ls | awk '{print $3}' | sed -n '2p')

## Remove the last image ID 
podman image rm $(podman image ls | awk '{print $3}' | sed -n '2p')

## Retrieve Container IP
PODIP=$(podman inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $PODID)

## SSH into container
ssh -v -i .ssh/idkey.pub root@localhost -p 20188
ssh -v sshuser@localhost -p 20188

podman exec -it ss /bin/bash
podman exec -it mdc /bin/bash

podman run -d --rm --name=agent --publish 2200:22 -e "JENKINS_AGENT_SSH_PUBKEY=.ssh/idkey.pub" jenkins/ssh-agent
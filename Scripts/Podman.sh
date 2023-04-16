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
PODID=$(podman run -idt --name mdc localhost/mina-developer-container)
podman attach $PODID

## List created and running containers
podman ps -a

## List images
podman image list -a

## Remove image
podman image rm localhost/mina-developer-container

## Create the container
podman build -t mina-developer-container .

## Get the last image ID from podman
LAST=$(podman image ls | awk '{print $3}' | sed -n '2p')

## Remove the last image ID 
podman image rm $(podman image ls | awk '{print $3}' | sed -n '2p')
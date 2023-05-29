# Created by rhvall
# May 2023
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

FROM gitpod/workspace-node-lts

LABEL version="0.1"
LABEL description="Mina Developer Container for quick zkApp development with Gitpod"

ARG DEBIAN_FRONTEND=noninteractive

EXPOSE 20188
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# shellcheck source=/dev/null
RUN apt-get -y update \
    && git clone --recurse-submodules https://github.com/rhvall/MinaDevContainer -b Release \
    && chmod +x /MinaDevContainer/Scripts/InstallMina.sh \
    && chmod +x /MinaDevContainer/Scripts/InstallzkAppExamples.sh \
    && /MinaDevContainer/Scripts/InstallMina.sh \
    && /MinaDevContainer/Scripts/InstallzkAppExamples.sh 

WORKDIR "/MinaDevContainer"
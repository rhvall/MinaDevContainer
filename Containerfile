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

FROM ubuntu:22.04

LABEL version="0.1"
LABEL description="Mina Developer Container for quick zkApp development."

ARG DEBIAN_FRONTEND=noninteractive

EXPOSE 20188
ENV NODE_VERSION=18.16.0
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# shellcheck source=/dev/null
RUN apt-get -y update \
    && apt-get -y install --no-install-recommends git=1:2.34.1-1ubuntu1 ca-certificates=20211016 curl=7.81.0-1 libcurl4=7.81.0-1 unzip=6.0-26ubuntu3 ssh=1:8.9p1-3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'root:password' | chpasswd \
    && sed -i 's/#Port 22/Port 20188/g' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config \
    && sed -i 's|#AuthorizedKeysFile|AuthorizedKeysFile /root/.ssh/authorized_keys|g' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    # && sed -i 's|#ChrootDirectory none|ChrootDirectory /MinaDevContainer|g' /etc/ssh/sshd_config \
    && mkdir /root/.ssh/ \
    && mkdir /var/run/sshd \
    && dpkg-reconfigure openssh-server
    # && service ssh start 

RUN git clone --recurse-submodules https://github.com/rhvall/MinaDevContainer -b Release \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  \
    && nvm install ${NODE_VERSION} \
    && nvm use v${NODE_VERSION} \
    && nvm alias default v${NODE_VERSION} \
    && npm install -g zkapp-cli@0.7.5 \
    && chmod +x /MinaDevContainer/Scripts/InstallMina.sh \
    && chmod +x /MinaDevContainer/Scripts/InstallzkAppExamples.sh \
    && /MinaDevContainer/Scripts/InstallMina.sh \
    && /MinaDevContainer/Scripts/InstallzkAppExamples.sh 

WORKDIR "/MinaDevContainer"

COPY .ssh/idkey.pub /root/.ssh/authorized_keys
COPY Scripts/Entrypoint.sh /Entrypoint.sh
# grr, ENTRYPOINT resets CMD now
#ENTRYPOINT []

## Start the ssh deamon
ENTRYPOINT ["sh", "/Entrypoint.sh"]
# CMD ["/usr/sbin/sshd", "-D"]

## Enable a bash session
#CMD ["/bin/bash"]
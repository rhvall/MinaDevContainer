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

ARCH="$(uname -m)"
 
if [ "${ARCH}" = "arm64" ]; then
    echo "Mina does not support ARM64 architecture"
    exit 1
fi

echo "Install Mina script"
echo "deb [trusted=yes] http://packages.o1test.net/ CODENAME unstable" | tee /etc/apt/sources.list.d/mina-unstable.list \
&& apt-get -y update \
&& apt-get -y install --no-install-recommends mina-berkeley=2.0.0rampup1-rampup-b1facec mina-zkapp-test-transaction=2.0.0rampup1-rampup-b1facec
#mina-mainnet=1.3.1.2-25388a0 

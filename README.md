# [Mina Developer Container (MDC)](https://container.minadev.eth.limo)
[![Open in Gitpod](Images/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/rhvall/MinaDevContainer)

A comprehensive developer environment for Mina's ZKApps, offering all the necessary software to "compile -> deploy -> run". Whether you're a newcomer or an experienced developer, the Mina Developer Container provides an isolated workspace with a repository deployment for easy exploration and replicable dev/test environments for customization. Simplify your workflow and unleash your creativity with a ready-to-go environment.

## Features

![MDC Overview](/Images/MinaInsightsContainer.png)

- Click-to-run Mina developer environment
- Open-source repository with everything needed to set up on private computers
- A cloud dev environment that runs on the web (plus Gitpods)
- A link to the docker environment for power users.

Once deployed, the "Mina Developer Container (MDC)" fulfills the needs of new and advanced developers with three run modes:

- [Remote deployment, web interface](/Images/RemoteWeb.png): In this mode, any user would just sign in with an account, press play, and a Cloud VM will deploy the MDC. The interface shown to the user would be an instance of VSCode configured with all the software needed to deploy the tutorials or custom code.
- [Remote deployment, local interface](/Images/RemoteLocal.png): Using VSCode SSH remote desktop, is as simple as deploying MDC on a powerful Cloud VM and connecting to the IP of that instance. When compiling and creating proofs, it uses remote resources, not local ones.
- [Local deployment, local interface](/Images/LocalLocal.png): More advanced users would be able to deploy a local MDC running docker in their computer. This mode would also consider VSCode SSH remote desktop, but using the resources in the user's computer.

According ot the way you execute the MDC project, you will have different dependencies. The easiest way to execute is to connect to the online service using the "Remote deployment & Web interface".

## MDC deployment

To deploy MDC in your computer or a remote server, you will first need to [install Docker](https://docs.docker.com/get-docker/) (or [Podman](https://podman.io/)) according to the operative system you use. 

**_NOTE:_** If you need to run a Mina node, you will require an `x86` computer

### Running the container

The simplest way is to `pull` the container from the docker registry as follows and run it locally as follows:

```
## Get the MDC image
docker pull minadevcont/mina-developer-container
## Run the MDC
docker run -idt --rm --name mdc -p 20188:20188 mina-developer-container
```
To break down the commands:
- `idt`: It means to run an `i`nterative (Keep STDIN), `d`etached (in the background) and with a `t`erminal (allocate a TTY)
- `rm`: Automatically remove the container when it exits. If you are working on something, remember to commit to your repository
- `name`: The name of the container
- `p`: The port to associate to the container. This instance use 20188 to expose the SSH connection.

If you are iterating the container deployment, file [Docker.sh](/Scripts/Docker.sh) contains multiple commands that could guide you to administrate your MDC.

The container is located in [dockerhub](https://hub.docker.com/r/minadevcont/mina-developer-container).

## Local interface dependencies

The recommended way to develop with a local experience connecting to the container is using [Visual Studio Code](https://code.visualstudio.com/) with the [Remote Development Plugin](https://code.visualstudio.com/docs/remote/ssh)

### Connecting to the container

The `run` command above will place the container in the background. From there, it is possible to connect using SSH or TTY:

```
## Connect using SSH
ssh -v -i .ssh/idkey root@localhost -p 20188
## OR
## Connect using TTY
docker exec -it mdc /bin/bash
```

## Run Mina examples

Once you are connected to the container, you can access a clone of this repository at the root as `/MinaDevContainer`, which will contain the following folder structure:

- Images: PNG Digital assets
- Scripts: Code that helps to run and interact with third party tools 
- Dependencies: The Mina zkApp examples repository

Therefore, to run the zkApp "Hello World", it is as simple as running these commands:

```
cd /MinaDevContainer/Dependencies/zkApp-Examples/
npm install
npm run build
npm run main01
```

These lines will change the current directory, install and compile the zkApp example.

## Documentation

Read more about the MDC [here](https://github.com/rhvall/MinaDevContainer/wiki) 

## License
[Apache-2.0](/LICENSE)
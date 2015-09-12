# che-docker-allplugins
Dockerfile to create an image of Eclipse Che with all the plugins from the docs.

Base on [Codenvy Che Dockerfile](https://github.com/codenvy/dockerfiles/tree/master/base/che) and [Che Docs](https://eclipse-che.readme.io/docs/plug-ins)

For: [Eclipse Che](http://www.eclipse.org/che/)

# Example on how to create a docker image
> SO distribution: Debian
### Install Docker
```bash
cd ~
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker metics
```
### Create the local folders for Che and pull this repo
```bash
mkdir -p .che
mkdir -p che/temp/fs-root
git clone https://github.com/jobcespedes/che-docker-allplugins.git che/docker
chmod 757 -R .che
chmod 757 -R che/temp/fs-root
```
### Build the image
```bash
docker build -t "mydocker/che:3.12.2-plugins" -f che/docker/Dockerfile che/docker
```
### Run a container
```bash
docker run -it -p 8080:8080 -p 49152-49162:49152-49162 -v ~/.che:/home/user/.che -v ~/che/temp/fs-root:/home/user/che/temp/fs-root -v ~/.che:/home/user/che/temp/local-storage mydocker/che:addplugins
```

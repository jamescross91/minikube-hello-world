# minikube-hello-world
A very simple Minikube Hello World example, this application will:
* A Python 3.8 Flask web application with a simple Hello World web page, packaged in a Debian Buster Python 3.8.2 Docker container
* Use Helm to package and deploy the Kubernetes components
* Deploy a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)] containing a configurable number of replicas
* Create a Kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/) load balancer to front the deployment

This application is not minikube specific and will work/deploy to whichever Kubernetes cluster is configured so long as that cluster is able to pull from your local Docker image registry, it has been tested using Docker Desktop for Mac, with Kubernetes 1.15.5.

## Components used
* Helm - version Kubernetes deployments
* Kubernetes deployment  - to manage groups of stateless pods, fronted by a Kubernetes service
* Makefile - to make local setup easier
* Docker - images
* Python/Flask - application and web server

## Prerequisites
TODO: Tabluate:
* Minikube with Kubernetes 1.15.x or Docker for Mac
* Make 3.8.x
* Bash
* Python 3.x to run locally
* Docker 19.x
* Helm 2.16.x with tiller installed on the cluster
* Kubectl 1.15.x or better

## Deployment Instructions
This is extremely easy, thanks to the Makefile (obviously ensure make is installed!).  There are a few targets that have been created to make this simple:
* **clean** - removes any languishing helm packages
* **build** - builds the docker image
* **package** - packages the helm chart
* **upgrade** - runs clean, build, package, and then a helm upgrade command

### To deploy from scratch:
1. Read the prerequisites
2. Clone this repo
3. Run `make upgrade DOCKER_IMAGE_PATCH_VERSION=$RANDOM`.  Note this generates a random [semver patch](https://semver.org) for the Docker image.  This is to workaround the fact that if you're using minikube or Docker Desktop, Kubernetes won't be able to read your local Docker image registry and as such imagePullPolicy is set to never.

The output of this command will let you know what has been launched and where the service is running, for example:
```
Release "minikube-hello-world" has been upgraded.
LAST DEPLOYED: Thu Apr  9 15:29:55 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME                  READY  UP-TO-DATE  AVAILABLE  AGE
minikube-hello-world  3/3    1           3          124m

==> v1/Pod(related)
NAME                                   READY  STATUS             RESTARTS  AGE
minikube-hello-world-55cc8d9bdc-s6n4c  0/1    ContainerCreating  0         0s
minikube-hello-world-7d59c48b8d-7phzv  1/1    Running            0         20m
minikube-hello-world-7d59c48b8d-swrn5  1/1    Running            0         20m
minikube-hello-world-7d59c48b8d-v9js5  1/1    Running            0         20m

==> v1/Service
NAME                          TYPE      CLUSTER-IP      EXTERNAL-IP  PORT(S)         AGE
minikube-hello-world-service  NodePort  10.103.233.167  <none>       8080:30925/TCP  87m
```

shows us that the service has been deployed, and is mapping port `8080` on the internal pods to port `30925` on each Kubernetes node, in our case localhost.

Browsing to `http://localhost:30925` will show the Hello World page as defined in [hello_world.py](minikube-hello-world/hello_world.py).

## Customisation
Certain elements can be customised:
* Image repository
* Image tag
* Image pull policy
* Number of replicas
* Application name

You can either update the [helm values.yaml file](minikube-hello-world/values.yaml) or update the `--set` lines on the helm upgrade command in [makefile](Makefile).  Note that `--set` takes precedence over changes to [values.yaml](minikube-hello-world/values.yaml)


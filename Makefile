DOCKER_IMAGE_PATCH_VERSION = 0
DOCKER_IMAGE_VERSION = 1.0.${DOCKER_IMAGE_PATCH_VERSION}
HELM_PACKAGE_VERSION = 1.0.0

clean:
		@rm -rf minikube-hello-world-*.tgz

build:
		docker build -t jamescross91/mkhelloworld:${DOCKER_IMAGE_VERSION} .

package:
		helm package minikube-hello-world --version ${HELM_PACKAGE_VERSION}

upgrade: clean build package
		helm upgrade minikube-hello-world minikube-hello-world/ \
		--install \
		--set image.repository="jamescross91" \
		--set image.tag=${DOCKER_IMAGE_VERSION} \
		--set image.pullPolicy="Never" \
		--set deployment.replicas=3 \
		--set deployment.appname="minikube-hello-world"

install: update clean

TARGET_OS ?= linux
TARGET_ARCH ?= amd64

OUT_DIR := ./dist

.DEFAULT_GOAL := all

ifneq ($(wildcard ./private/charts/opencomponents-registry),)
VALUES_PATH := ./private/charts/opencomponents-registry/values.yaml
else
VALUES_PATH := ./charts/opencomponents-registry/values.yaml
endif

DOCKER_REGISTRY ?= ghcr.io/jr200
IMAGE_TAG ?= local
IMAGE_NAME ?= opencomponents-registry
K8S_NAMESPACE ?= opencomponents-registry

################################################################################
# Target: start-local                                                          #
################################################################################
.PHONY: start-local
start-local:
	npm run start

################################################################################
# Target: docker-run                                                 #
################################################################################
.PHONY: docker-run
docker-run:
	podman run \
		--rm \
		--env-file .env \
		-p 9000:80 \
		$(IMAGE_NAME):$(IMAGE_TAG)

################################################################################
# Target: docker-debug
################################################################################
.PHONY: docker-debug
docker-debug:
	podman run \
		--rm \
		--env-file .env \
		-it \
		--entrypoint sh \
		-p 9000:80 \
		$(IMAGE_NAME):$(IMAGE_TAG)


################################################################################
# Target: docker-build                                                 #
################################################################################
.PHONY: docker-build
docker-build:
	podman build \
		-f docker/Dockerfile \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--layers=true \
		.

################################################################################
# Target: helm chart dependencies
################################################################################
.PHONY: chart-deps
chart-deps:
	helm dependency build charts/opencomponents-registry --skip-refresh
	kubectl create namespace $(K8S_NAMESPACE) || echo "OK"

################################################################################
# Target: helm chart install
################################################################################
.PHONY: chart-install
chart-install: chart-deps
	helm upgrade -n $(K8S_NAMESPACE) opencomponents-registry \
		--install \
		-f $(VALUES_PATH) \
		charts/opencomponents-registry

################################################################################
# Target: helm template
################################################################################
.PHONY: chart-template
chart-template: chart-deps
	helm template -n $(K8S_NAMESPACE) opencomponents-registry \
		-f $(VALUES_PATH) \
		--debug \
		charts/opencomponents-registry

################################################################################
# Target: helm template
################################################################################
.PHONY: chart-dry-run
chart-dry-run:
	helm install \
		-n $(K8S_NAMESPACE) \
		-f $(VALUES_PATH) \
		--generate-name \
		--dry-run \
		--debug \
		charts/opencomponents-registry

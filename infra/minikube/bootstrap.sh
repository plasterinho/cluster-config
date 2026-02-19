#!/usr/bin/env bash

# Bootstrap the kubernetes cluster with a default, simple minikube config

set -e

K8S_VERSION=v1.35.0

minikube start \
  --driver=docker \
  --kubernetes-version=${K8S_VERSION} \
  --cpus=4 \
  --memory=8192

# Enable some addons
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable volumesnapshots
minikube addons enable dashboard
minikube addons enable csi-hostpath-driver


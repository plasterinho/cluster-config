#!/usr/bin/env bash
set -e

K8S_VERSION=v1.35.0

echo "Starting minikube..."
minikube start \
  --driver=docker \
  --kubernetes-version=${K8S_VERSION} \
  --cpus=4 \
  --memory=8192

echo "Enabling addons..."
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

echo "Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.3.1/manifests/install.yaml

echo "Bootstrapping root application..."
kubectl apply -f argocd/applications/local.yaml

echo "Done."


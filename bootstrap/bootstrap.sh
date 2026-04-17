#!/usr/bin/env bash
set -e

K8S_VERSION=v1.35.1

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

# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.3.1/manifests/install.yaml

# wait for readiness
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# make sure argocd-server is restarted to pick up the new secret
kubectl -n argocd get secret argocd-secret >/dev/null 2>&1 || \
kubectl -n argocd rollout restart deployment argocd-server

# bootstrap gitops
kubectl apply -f https://raw.githubusercontent.com/plasterinho/cluster-config/main/gitops/argocd/applications/root-app.yaml

echo "Done."

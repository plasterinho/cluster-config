#!/bin/env bash

# Remove old MetalLB
minikube addons disable metallb
kubectl delete ns metallb-system

# Download the current version
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

# Update Docker
docker pull quay.io/metallb/controller:v0.15.3
docker pull quay.io/metallb/speaker:v0.15.3

minikube image load quay.io/metallb/controller:v0.15.3
minikube image load quay.io/metallb/speaker:v0.15.3

# Configure MetalLB
kubectl apply -f metallb-config.yaml

# Patch the ingress service type to LB (MetalLB ignores NodePoint)
kubectl patch svc ingress-nginx-controller \
  -n ingress-nginx \
  -p '{"spec": {"type": "LoadBalancer"}}'

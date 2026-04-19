#!/usr/bin/env bash
set -euo pipefail

K8S_VERSION=v1.35.1
ARGO_VERSION=v3.3.1
REPO="https://github.com/plasterinho/cluster-config.git"
ARGO_INSTALL_URL="https://raw.githubusercontent.com/plasterinho/cluster-config/main/gitops/argocd/base/install.yaml"
ROOT_APP_URL="https://raw.githubusercontent.com/plasterinho/cluster-config/main/gitops/argocd/applications/root-app.yaml"

echo "🚀 Starting minikube..."
minikube start \
  --driver=docker \
  --kubernetes-version=${K8S_VERSION} \
  --cpus=4 \
  --memory=8192

echo "✨ Enabling addons..."
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

echo "📥 Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# install argocd with server-side apply to avoid issues with CRD versions
kubectl apply --server-side -n argocd -f "${ARGO_INSTALL_URL}"

echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

echo "🌱 Bootstrapping root application..."
kubectl apply -f ${ROOT_APP_URL}

echo "✅ Done."
echo ""
echo "🎉 Your cluster is ready! Access ArgoCD UI with:"
minikube service argocd-server -n argocd --url
echo ""
echo "🔐 Default ArgoCD credentials:"
echo "   Username: admin"
echo "   Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)"

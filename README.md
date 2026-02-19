# cluster-config

Infrastructure and GitOps configuration for the local Kubernetes
environment used in the Platform Engineering Stack Learning journey.

This repository contains:

- Kubernetes application manifests (Kustomize-based)
- Environment composition
- ArgoCD Applications
- Cluster bootstrap automation (minikube + ArgoCD)

The goal is full reproducibility from zero to running application.

------------------------------------------------------------------------

## Architecture Overview

The system is layered:

1. **Cluster Layer** -- Minikube
2. **GitOps Controller** -- ArgoCD
3. **Applications** -- Managed declaratively via Kustomize

ArgoCD reconciles everything under `gitops/`.

Bootstrap scripts provision the cluster and install ArgoCD.

------------------------------------------------------------------------

## Repository Structure

```text
cluster-config/ 
├── bootstrap/ \# Cluster bootstrap automation 
│ └── bootstrap.sh 
├── gitops/ 
│ ├── apps/ \# Application definitions (base + overlays) 
│ ├── environments/ \# Environment composition (e.g., local) 
│ └── argocd/ \# ArgoCD Application CRs 
└── README.md
```

------------------------------------------------------------------------

### gitops/apps

Contains application definitions using Kustomize:

- `base/` -- environment-agnostic resources
- `overlays/` -- environment-specific modifications

### gitops/environments

Defines composed environments.\
Example: `local` aggregates application overlays and ingress.

### gitops/argocd

Defines ArgoCD `Application` resources.\
These point ArgoCD to the desired environment path.

------------------------------------------------------------------------

## Bootstrap From Scratch

### 1. Start Cluster + Install ArgoCD

./bootstrap/bootstrap.sh

This script:

- Starts Minikube (pinned Kubernetes version)
- Enables required addons
- Installs ArgoCD (version pinned)
- Bootstraps the root ArgoCD Application

------------------------------------------------------------------------

### 2. Access ArgoCD

Port-forward:

kubectl port-forward svc/argocd-server -n argocd 8080:443

Then open:

<https://localhost:8080>

------------------------------------------------------------------------

### 3. Access OpsJournal

Ensure ingress addon is enabled and `/etc/hosts` contains:

`<minikube-ip>`{=html} opsjournal.local

Get IP:

minikube ip

Then open:

<http://opsjournal.local>

------------------------------------------------------------------------

## GitOps Flow

All application changes must go through Git.

1. Modify manifests in `gitops/`
2. Commit
3. Push
4. ArgoCD reconciles automatically

Do not manually apply manifests under `gitops/` with `kubectl apply`.

------------------------------------------------------------------------

## Design Principles

- Declarative state over imperative commands
- Environment composition via Kustomize
- Git as the source of truth
- Cluster disposable and reproducible
- Clear separation between bootstrap layer and GitOps layer

------------------------------------------------------------------------

## Current Scope

- Single cluster (local)
- Single environment (`local`)
- Single application (OpsJournal)
- Manual bootstrap of ArgoCD

Future iterations may include:

- App-of-apps pattern
- Self-managed ArgoCD
- Multiple environments
- CI integration

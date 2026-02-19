# cluster-config

Declarative cluster and GitOps configuration for a local Kubernetes
platform built as part of the *Platform Engineering Stack Learning*
journey.

This repository demonstrates:

- Kubernetes application structuring with Kustomize
- Environment composition patterns
- GitOps workflow using ArgoCD
- Reproducible cluster bootstrap with Minikube
- Clear separation between infrastructure bootstrap and application
    reconciliation

The focus is not just "running Kubernetes", but designing a
**reproducible, disposable, and declarative platform environment**.

------------------------------------------------------------------------

## Architectural Overview

The system is structured in explicit layers:

1. **Cluster Layer** -- Minikube (ephemeral, reproducible)
2. **GitOps Controller Layer** -- ArgoCD (state reconciliation engine)
3. **Application Layer** -- OpsJournal (managed declaratively)

Each layer has a clearly defined responsibility:

- The cluster provides compute and networking primitives.
- ArgoCD reconciles desired state from Git.
- Applications are defined declaratively and environment-aware.

The cluster can be deleted and recreated at any time without losing
desired state.

------------------------------------------------------------------------

## Repository Structure

```text
cluster-config/
├── bootstrap/ \# Imperative bootstrap layer (cluster + ArgoCD) 
│ └── bootstrap.sh 
├── gitops/ 
│ ├── apps/ \# Application definitions (base + overlays) 
│ ├── environments/ \# Environment composition (e.g., local) 
│ └── argocd/ \# ArgoCD Application CRs 
└── README.md
```

### bootstrap/

Contains automation required to:

- Start Minikube (pinned Kubernetes version)
- Enable required cluster addons
- Install ArgoCD (version pinned)
- Bootstrap the root ArgoCD Application

This layer intentionally remains imperative, as GitOps requires an
initial controller bootstrap.

### gitops/

Everything under this directory is reconciled by ArgoCD.

#### apps/

Applications follow a structured Kustomize layout:

- `base/` -- environment-agnostic resources
- `overlays/` -- environment-specific configuration

#### environments/

Defines environment composition.\
For example, `local/` aggregates:

- Application overlays
- Ingress definitions
- Environment-specific configuration

This allows scaling from a single app to multi-app environments cleanly.

#### argocd/

Defines ArgoCD `Application` resources declaratively.

These point ArgoCD to environment paths and define sync policies.

------------------------------------------------------------------------

## Bootstrap From Scratch

From a clean machine:

### 1. Bootstrap the Cluster

./bootstrap/bootstrap.sh

This performs:

- Minikube startup (version pinned)
- Addon enablement
- ArgoCD installation
- Initial GitOps Application creation

### 2. Access ArgoCD

kubectl port-forward svc/argocd-server -n argocd 8080:443

Open:

<https://localhost:8080>

### 3. Access OpsJournal

Add to `/etc/hosts`:

`<minikube-ip>`{=html} opsjournal.local

Retrieve IP:

minikube ip

Then open:

<http://opsjournal.local>

------------------------------------------------------------------------

## GitOps Workflow

All application and environment changes flow through Git.

1. Modify manifests under `gitops/`
2. Commit and push
3. ArgoCD detects change
4. Cluster reconciles automatically

Manual `kubectl apply` is intentionally avoided for Git-managed
resources.

------------------------------------------------------------------------

## Design Principles Demonstrated

- Cluster as cattle, not pet
- Declarative desired state
- Environment composition via Kustomize
- Git as the single source of truth
- Explicit bootstrap layering
- Safe destructive operations (cluster recreation)

------------------------------------------------------------------------

## Current Scope

- Single local cluster
- Single environment (`local`)
- Single application (OpsJournal)
- ArgoCD installed via bootstrap layer

------------------------------------------------------------------------

## Planned Evolution

- App-of-apps pattern
- Self-managed ArgoCD
- Multi-environment support
- CI integration
- Policy and validation layers

------------------------------------------------------------------------

This repository reflects an incremental evolution from imperative
experimentation toward structured platform design and reproducibility.

# Bootstrap the cluster

This directory contains two scripts for bootstrapping the cluster from scratch:

- `bootstrap.sh` — uses the local repository for most resources
- `bootstrap-all.sh` — fetches all resources directly from the internet

Both scripts perform the same steps; they differ only in how they source configuration files.

## Run from a local repository

```bash
./bootstrap.sh
```

## Run without cloning the repository

To install directly, run:

```bash
curl -sL https://raw.githubusercontent.com/plasterinho/cluster-config/main/bootstrap/bootstrap.sh | bash
```

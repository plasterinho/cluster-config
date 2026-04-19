# Panel definitions for the Grafana dashboard

Panel definitions live in `panels/*.json`.

`dashboard.base.json` contains the shared dashboard metadata, and
`build-dashboard.py` combines the base file with the panel files into
`../dashboard.json`.

When you change any panel file, regenerate the combined dashboard with:

```bash
python dashboards/build-dashboard.py
```

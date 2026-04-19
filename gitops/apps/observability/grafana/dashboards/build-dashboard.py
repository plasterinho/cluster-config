from __future__ import annotations

import json
from pathlib import Path


def main() -> None:
    dashboards_dir = Path(__file__).resolve().parent
    base_path = dashboards_dir / "dashboard.base.json"
    panels_dir = dashboards_dir / "panels"
    output_path = dashboards_dir.parent / "dashboard.json"

    dashboard = json.loads(base_path.read_text(encoding="utf-8"))
    panel_paths = sorted(panels_dir.glob("*.json"))
    dashboard["panels"] = [
        json.loads(panel_path.read_text(encoding="utf-8")) for panel_path in panel_paths
    ]

    output_path.write_text(
        json.dumps(dashboard, indent=2) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()

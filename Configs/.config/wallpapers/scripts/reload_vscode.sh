#!/usr/bin/env python3

import json
import shutil
import re
from pathlib import Path

HOME = Path.home()
PYWAL_COLORS = HOME / ".cache/wal/colors-vscode.json"
TARGET_SETTINGS = HOME / ".config/Code/User/settings.json"
BACKUP_SETTINGS = HOME / ".config/Code/User/settings-backup.json"

if not BACKUP_SETTINGS.exists():
    shutil.copy(TARGET_SETTINGS, BACKUP_SETTINGS)

with open(PYWAL_COLORS, 'r') as f:
    content = f.read()
    content = re.sub(r'//.*?\n', '\n', content)
    content = '{' + content + '}'
    pywal_data = json.loads(content)

with open(TARGET_SETTINGS, 'r') as f:
    settings = json.load(f)

settings["workbench.colorCustomizations"] = pywal_data["workbench.colorCustomizations"]

with open(TARGET_SETTINGS, 'w') as f:
    json.dump(settings, f, indent=2)
#!/bin/bash
# Resets the lawn skill to first-run state for testing.
# Deletes all generated data files and clears lawn-related memory.
# Does NOT touch docs/, lawn.md, or git history.

set -e

LAWN_DIR="$HOME/Claude/Lawn"
MEMORY_DIR="$HOME/.claude/projects/-Users-kevin-Claude-Lawn/memory"

echo "Resetting /lawn skill to first-run state..."

# Remove generated data files
rm -f "$LAWN_DIR/lawn-profile.json"
rm -f "$LAWN_DIR/treatment-schedule.json"
rm -f "$LAWN_DIR/activity-log.json"
rm -f "$LAWN_DIR/weather-log.json"
rm -f "$LAWN_DIR/inventory.json"

# Reset memory to baseline (keeps index, removes lawn profile memory)
cat > "$MEMORY_DIR/project_lawn_skill.md" << 'EOF'
---
name: Lawn Care Skill Project
description: Core context for the /lawn Claude skill project — what we're building, where things live, and the app-forward vision
type: project
---

**STATUS: v1.0 COMPLETE** — `/lawn` skill is built, evaluated, and committed.

**Skill file:** `~/.claude/skills/lawn.md`
**Data directory:** `~/Claude/Lawn/` (JSON files — app-ready model)

**Skill modes:** Setup (satellite map + zones), Plan (soil-temp-driven calendar), Diagnose (photo analysis + differential), Log, Inventory, Q&A
EOF

echo "Done. Lawn profile, logs, schedule, inventory, and memory cleared."
echo "Start a new Claude Code session and run /lawn to simulate a fresh user."

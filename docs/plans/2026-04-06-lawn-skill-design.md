# Lawn Care Skill — Design Document

**Date:** 2026-04-06
**Status:** Approved

---

## Problem & Goal

Most homeowners — especially beginners — have no structured system for lawn care. They over-apply, under-apply, use the wrong products at the wrong time, and have no way to track what they've done. Commercial tools like Scotts and Yard Mastery exist but aren't conversational or personalized.

**Goal:** A shareable Claude skill (`/lawn`) that turns Claude into a knowledgeable, personalized lawn care advisor. It provisions its own project on first run, persists data across sessions, and scales from total beginner to serious enthusiast.

---

## Architecture

### Skill File
- Location: `~/.claude/skills/lawn.md`
- Type: Shareable (generic — no hardcoded user data)
- Invocation: `/lawn` from any Claude Code session

### Project Directory (created on first run)
```
~/Claude/Lawn/
  lawn-profile.json       # address, zip, zones, grass type, equipment
  treatment-schedule.json # full-year calendar with dates and amounts
  activity-log.json       # mow/application history
  weather-log.json        # conditions, soil temps, frost dates, rainfall
  inventory.json          # products and equipment on hand
  docs/
    plans/                # design docs and implementation plans
```

### Memory (Claude memory system)
- Quick-recall layer: zones, grass type, last mow date, current season, open issues
- Summary only — full data lives in JSON files

---

## Modes

| Mode | Trigger | Description |
|------|---------|-------------|
| **Setup** | First run / "reset my lawn" | Provisions project dir, guides through profile creation |
| **Plan** | "plan", "schedule", "what this week/month" | Generates or queries treatment calendar |
| **Diagnose** | "I'm seeing", "why is my grass", share a photo | Structured triage + treatment recommendation |
| **Log** | "I just mowed", "I applied X today" | Records activity to log |
| **Inventory** | "I have a new mower", "what do I have" | Manages equipment and product inventory |
| **Q&A** | Everything else | General advice, newbie explanations, comparisons |

---

## Setup Flow (First Run)

1. Detect no `lawn-profile.json` exists → enter setup mode
2. Create `~/Claude/Lawn/` directory structure
3. Ask for address or zip code
4. Open Google Maps satellite view in browser (Chrome MCP) for visual yard confirmation
5. Guide user through naming and estimating zones (front lawn, backyard, side strips, beds)
6. Detect grass type from region; confirm with user
7. Capture equipment inventory (mower, trimmer, spreader, blower, etc.)
8. Capture products currently on hand
9. Save `lawn-profile.json` and memory summary
10. Offer to generate initial treatment schedule

---

## Treatment Planner

### Knowledge Sources
- **Scotts 4-Step Program**: Spring (early + late), Summer, Fall cadence
- **Yard Mastery methodology**: Soil temperature triggers (not air temp) for timing
  - Pre-emergent: soil temp 50-55°F
  - Warm-season fertilizer: soil temp ≥65°F at 4" depth
  - Seeding: 2+ months before first frost
- **Regional differentiation**:
  - Cool-season (Northeast, Midwest): Kentucky bluegrass, tall fescue, ryegrass — peak care spring/fall
  - Warm-season (Southeast): Bermuda, St. Augustine, Zoysia — peak care summer
  - Transition zone: hybrid scheduling

### Generated Calendar
- Dates personalized to zip code (using local frost dates + avg soil temp curves)
- Per-zone product quantities calculated from sq footage
- "What should I do this week?" uses current weather + schedule position
- Weather pulled via web search when generating recommendations

---

## Problem Diagnosis Flow

1. User describes symptom OR shares a photo
2. If photo: Claude analyzes visually first, identifies likely issues
3. Structured follow-up questions:
   - Which zone? How widespread?
   - When did it start?
   - Recent treatments or weather events?
4. Diagnosis: disease, pest, nutrient deficiency, watering issue, compaction, shade
5. Treatment recommendation with product + rate + timing
6. Prevention added to schedule going forward
7. Newbie explanation of the "why" behind every recommendation

---

## Data Model

### `lawn-profile.json`
```json
{
  "address": "123 Main St",
  "zip": "12345",
  "region": "northeast",
  "grassType": "tall-fescue",
  "zones": [
    { "name": "Front Lawn", "sqft": 1200, "notes": "partial shade" },
    { "name": "Backyard", "sqft": 2400, "notes": "full sun, dog traffic" }
  ],
  "equipment": [
    { "type": "mower", "brand": "Honda", "model": "HRX217" }
  ],
  "createdAt": "2026-04-06"
}
```

### `activity-log.json`
```json
[
  {
    "date": "2026-04-06",
    "type": "mow",
    "zone": "all",
    "height": "3.5in",
    "notes": ""
  },
  {
    "date": "2026-04-01",
    "type": "application",
    "product": "Scotts Turf Builder Triple Action",
    "zone": "Front Lawn",
    "rate": "1 bag / 1200 sqft",
    "notes": "soil temp was 52°F"
  }
]
```

### `weather-log.json`
```json
{
  "zip": "12345",
  "frostDates": { "last": "2026-04-15", "first": "2026-10-20" },
  "events": [
    { "date": "2026-04-06", "soilTemp": 51, "airTemp": 58, "rainfall": 0.2 }
  ]
}
```

---

## Newbie Experience

Every response in the skill includes:
- Plain English explanation of what to do and **why**
- Safety notes (don't apply pre-emergent when seeding, etc.)
- Beginner mistakes to avoid
- "You're doing great" encouragement where appropriate

---

## Future App Readiness

The JSON data model is deliberately app-ready:
- Flat files = easy to load into React state or a database
- Normalized structure = supports multi-lawn, multi-user
- Activity log = full history for charts and analytics
- Zone model = maps directly to a visual map component

---

## Build Approach

This skill should be built using the `anthropic-skills:skill-creator` skill to ensure:
- Proper skill file format and frontmatter
- Trigger conditions documented
- Evaluation criteria defined
- Skill is tested before deployment

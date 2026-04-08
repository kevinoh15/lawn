# /lawn — Claude Lawn Care Skill

A shareable Claude Code skill that turns Claude into a personalized lawn care advisor. Built for beginners who want a better lawn and an easy way to plan, track, and troubleshoot.

## What it does

**Setup** — Enter your address, view your yard in Google Maps satellite view, define zones with square footage, detect your grass type, and log your equipment and products on hand.

**Plan** — Get a full-year treatment calendar or a specific "what should I do this week?" recommendation. Powered by live soil temperature data — not just a generic calendar.

**Diagnose** — Describe a problem or share a photo. Get a structured differential diagnosis with confidence level, specific product recommendations, application rates, and a plain-English explanation of what's happening and why.

**Log** — Record mows, applications, waterings, and aerations. Track your season totals and automatically mark scheduled treatments as complete.

**Inventory** — Track products and equipment on hand. Check whether you have enough product for your yard before buying more.

## How to install

1. Copy `lawn.md` to `~/.claude/skills/lawn.md`
2. Create the data directory: `mkdir -p ~/Claude/Lawn`
3. Start a Claude Code session and say `/lawn` — it will walk you through setup

## First run

The skill detects that no profile exists and enters setup mode automatically. It will:
- Ask for your address or zip code
- Open Google Maps satellite view so you can see and describe your yard
- Walk you through naming zones and estimating square footage
- Detect your grass type from your region
- Capture your equipment and products on hand

Everything gets saved to `~/Claude/Lawn/` as JSON files, designed to be app-ready for a future web or mobile build.

## Data files

All data lives in `~/Claude/Lawn/`:

| File | Contents |
|------|---------|
| `lawn-profile.json` | Address, zip, zones, grass type, equipment |
| `treatment-schedule.json` | Full-year treatment calendar |
| `activity-log.json` | Every mow, application, and watering |
| `weather-log.json` | Soil temperatures, frost dates, rainfall |
| `inventory.json` | Products and equipment on hand |

## Knowledge sources

- [Yard Mastery](https://yardmastery.com) — soil temperature methodology
- [Scotts 4-Step Program](https://scotts.com) — seasonal treatment cadence
- USDA regional frost date data for timing

## Requirements

- Claude Code
- Chrome MCP (optional — for Google Maps satellite view during setup)

## License

MIT

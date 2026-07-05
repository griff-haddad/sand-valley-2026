# Sand Valley 2026

Private trip itinerary dashboard for the July 8 to July 12, 2026 group golf trip to Sand Valley Golf Resort, Nekoosa, Wisconsin.

**Live URL:** https://griff-haddad.github.io/sand-valley-2026/

---

## The Trip

| | |
|---|---|
| **Dates** | Wednesday July 8 through Sunday July 12, 2026 |
| **Property** | Sand Valley Golf Resort, 1697 Leopold Way, Nekoosa, WI |
| **Cottage** | Lake Leopold, four double-queen rooms |
| **Group** | 8 golfers, split into two groups of four for tee times |
| **Roster** | Griffin Haddad, Radley Haddad, Zak Estes, Andru Creighton, Bob Haddad, Mike Essex, John Smeltzer, Steve Hullett |

## Repository Contents

| File / Folder | Purpose |
|---|---|
| `index.html` | The full dashboard, single self-contained file (~406 KB, Commons hero image base64-embedded) |
| `assets/commons-card.png` | Source Canva image for The Commons course card (2000×1250 PNG, the only asset not fetched from a public CDN) |
| `scripts/deploy.sh` | One-command deploy: copies source to repo, stamps a fresh build ID, commits, pushes |
| `scoreboard/` | The Sand Valley Cup live scoreboard (team Cup, individual race, skins). See `scoreboard/README.md` |
| `scripts/deploy-scoreboard.sh` | One-command deploy for the scoreboard (stamps build ID, commits, pushes) |
| `README.md` | This file |

## Design System

**Color coding for schedule events:**
- 🟢 Green (`#3f7a4e`) — Golf activities
- 🔵 Blue (`#2f5d7c`) — Meals
- 🟡 Yellow (`#c89321`) — Free time

**Typography:**
- Headers: Cormorant Garamond (serif)
- Body: Inter (sans-serif)

**Course card image spec:**
- Aspect ratio: 16:10
- Recommended: 2000×1250 px JPG
- Focal point should be centered (`background-size: cover`)
- Top-left reserved for the day/group badge
- Bottom 25% has a dark gradient overlay for readability

**Hero and section theming:** all key colors live as CSS custom properties at the top of the `<style>` block for quick retheming.

## Updating the Dashboard

1. Edit the source file at `/Users/griff/Downloads/sand-valley-2026.html`
2. Run the deploy script:
   ```bash
   /Users/griff/Downloads/deploy-sv2026.sh "Your commit message"
   ```
3. GitHub Pages redeploys automatically in ~30 seconds. If any viewers have the page open, they'll see a "New version available" toast within about 3 minutes.

**What the script does:** copies the source file into the deploy clone at `/tmp/sv2026-deploy/`, stamps a fresh build ID (needed for the update-detection toast to fire), commits, and pushes. If the deploy clone is missing (e.g., after a reboot cleared `/tmp/`), the script re-clones automatically.

An identical copy of the script lives in this repo at `scripts/deploy.sh` for archival purposes.

## Update Detection (Toast)

Each deployed HTML carries a `<meta name="build-id">` tag stamped at deploy time. On page load, JavaScript polls the site every 3 minutes and compares the current build ID against the one loaded. If they differ, a small "New version available" toast appears in the bottom-right corner offering a one-click refresh. Users who don't have the page open when an update lands will see the fresh version on their next natural visit.

## Sources & Credits

- **Course photos & logos:** [sandvalley.com](https://sandvalley.com) CDN (Webflow-hosted)
- **Hole-by-hole flyovers:** [coursepreview.golf](https://coursepreview.golf)
- **YouTube walkthrough videos:**
  - The Commons — https://www.youtube.com/watch?v=U90nAh9hcek
  - Sedge Valley — https://www.youtube.com/watch?v=c37EAZNo3Ac
  - Mammoth Dunes — https://www.youtube.com/watch?v=YuwPfFu0q7w
  - The Lido — https://www.youtube.com/watch?v=qoYYmUodp6s
- **The Commons hero image:** Custom Canva design (preserved in `assets/commons-card.png`)

## Regenerating from Scratch (Future Trips)

To adapt this template for another destination:
1. Copy `index.html` to a new file
2. Update the hero: swap the resort logo, year, dates, and meta pills
3. Update the day tabs (5 tabs in the schedule section, one per day)
4. Replace event cards inside each `.day-panel` (green/blue/yellow classes drive the color coding)
5. Swap the 6 course cards in the `.courses-grid` section (`background-image` for the photo, `<img class="course-logo">` for the logo)
6. Update dining cards, logistics tables, footer
7. Deploy per the update workflow above

## Deployment Notes

- Hosting: GitHub Pages (free tier)
- Source: `main` branch, root folder
- Public repo (required for free Pages)
- All assets self-contained except CDN references, so the file also works locally by double-clicking

# The Sand Valley Cup — Live Scoreboard

A single self-contained page that tracks the Ryder Cup style competition for the
trip: team points toward the Cup, an individual stroke/points race, and the
season-long skins game. Styled to match the itinerary dashboard.

- **File:** `scoreboard/index.html`
- **Live URL:** https://griff-haddad.github.io/sand-valley-2026/scoreboard/
- **Event:** Sand Valley Resort, July 8 to 12, 2026. 8 golfers, 7 rounds, 6 courses.
- **Teams:** Young Guns (green) vs. Old Guard (navy). First to 9.5 of 18 points wins.

---

## 1. How it works

The page is a **renderer over one `DATA` block** near the top of the `<script>`.
Nothing is computed live in the browser during the trip. Each night:

1. Read that day's scorecards (photos are fine).
2. Compute the results.
3. Edit only the results data in `scoreboard/index.html` (`results`, `individual`,
   `skins`, `mvp`, `potw`, `meta`).
4. Deploy (section 5). Everyone's page shows the new numbers on refresh, and
   anyone with the page open gets a "New scores posted" toast within ~3 minutes.

The page loads in an honest **pre-trip state** (0 to 0, countdown running). A
**"Show sample scores"** button in the bottom-right swaps in demo data so you can
preview the populated look. To go fully live, delete the `.demo` markup, the demo
button script, and the `DEMO` object.

---

## 2. Sections

| Section | What it shows |
|---|---|
| **Sticky live bar** | Persistent YG vs OG tally that follows you as you scroll |
| **Hero** | Title, dates, live status line, countdown to first tee |
| **Cup Meter** | Ryder Cup tug-of-war bar toward the gold 9.5 clinch line, plus a per-session rail |
| **The Sessions** | All 7 sessions as cards. Tap to expand format, counting rule, result |
| **Individual Race** | Sortable table: Thru, Gross (with to-par), Net (with to-par). Lowest net leads; crowns Player of the Week and Daily MVP |
| **The Skins Game** | Pot / skins won / carrying stats, plus a per-player winnings bar chart ranked by dollars, with skins count |
| **The Rosters** | Both teams with indexes and captain badges |

---

## 3. Design system (shared with the itinerary)

- **Fonts:** Cormorant Garamond (headings, big numbers), Inter (body, data). Loaded
  via the same Google Fonts link as `index.html`. Digits use `tabular-nums`.
- **Colors** (CSS variables in `:root`): paper `#fbf8f1`, ink `#1c1b18`,
  line `#e6dec9`; **Young Guns green `#3f7a4e`**, **Old Guard navy `#2f5d7c`**,
  **gold accent `#c89321`** (skins / MVP / clinch line). Soft/ink variants of each
  exist for chips and fills.

---

## 4. Data model

### Teams and players (static)
Two teams of four. Each player has a USGA index and Back-tee course handicaps by
course key. Captains flagged `cap:true`.

**Young Guns** — Capt. Griffin Haddad: Radley Haddad 3.7, Griffin Haddad 8.5,
Andru Creighton 10.4, Zak Estes 15.8.

**Old Guard** — Capt. Bob Haddad: John Smeltzer 5.3, Steve Hullett 7.3,
Bob Haddad 9.1, Mike Essex 16.3.

Course keys: `md` Mammoth Dunes, `lido` The Lido, `commons` The Commons (65%),
`sv` Sand Valley, `sedge` Sedge Valley. The Sandbox is a 17-hole par 3 played gross.

### Sessions (static) — 18 points, first to 9.5 wins
| # | Day | Course | Format | Counting | Pts |
|---|---|---|---|---|---|
| 1 | Wed 7/8 | The Sandbox | Best Ball | 1 of 4 front, 2 of 4 back | 2 |
| 2 | Thu 7/9 | Mammoth Dunes | Stableford | 2 of 4 front, 1 of 4 back | 2 |
| 3 | Thu 7/9 | The Lido | Best Ball | 2 of 4 front, 3 of 4 back | 2 |
| 4 | Fri 7/10 | The Commons | Mod. Stableford | 3 of 4 front, 4 of 4 back | 2 |
| 5 | Sat 7/11 | Sand Valley | Singles Match Play | 4 matches, captain's order 1-4 | 4 |
| 6 | Sat 7/11 | Sedge Valley | Singles Match Play | 4 matches, captain's order 1-4 | 4 |
| 7 | Sun 7/12 | Mammoth Dunes | Best Ball | 1 of 4 front, 1 of 4 back | 2 |

**Scoring keys**
- Stableford: eagle+ `+4`, birdie `+3`, par `+2`, bogey `+1`, double+ `0`.
- Modified Stableford: eagle+ `+5`, birdie `+3`, par `+1`, bogey `0`, double+ `-1`.
- 2-point sessions: each nine is worth 1 point (win 1, tie 0.5).
- Match-play sessions: 1 point per match, 4 matches.
- Skins: all 8 as one field, net, **$2/person/hole** ($16 a hole), ties push and
  carry. Buy-in $100/player.

### Live data (edit nightly)
- `results[]` — per session `{id, status:"pending"|"final", yg, og, blurb}` (points, halves ok).
- `individual[]` — `{name, played, gross, net, par}` where `par` = total par of holes played so far (to-par = strokes − par). Lowest net is the individual leader.
- `skins` — `{pot, claimed, carrying, byPlayer:[{name, dollars, skins}], note}`.
- `mvp` — `{who, desc}`; `potw` — `{who, desc}`; `meta` — `{status, updated}`.

There are two data objects: `EMPTY` (pre-trip zeros, shown by default) and `DEMO`
(sample preview). During the trip, update `EMPTY`.

### `cup.json` — feeds the itinerary ticker
The itinerary page shows a slim Cup ticker under the nav that reads
`scoreboard/cup.json`:

```json
{ "yg": 0, "og": 0, "target": 9.5, "total": 18, "status": "...", "updated": "" }
```

Each night, after updating the scoreboard's Cup total, set `yg` / `og` here to the
same running score and update `status` (e.g. "Day 3 · Old Guard chasing"). The
deploy script commits it automatically. The itinerary HTML itself never needs
editing again — only this file changes.

---

## 5. Deploying an update

From inside the repo:

```bash
./scripts/deploy-scoreboard.sh "Wednesday scores in"
```

This stamps a fresh build ID, commits, and pushes. GitHub Pages rebuilds in about
30 seconds. This is separate from the itinerary deploy (`scripts/deploy.sh`), so
the two never collide.

> Note: the itinerary deploy only touches `index.html`, so it never disturbs this
> `scoreboard/` folder, and vice versa.

---

## 6. Nav link on the itinerary (pending)

To link the scoreboard from the itinerary nav, add one entry to the source file
`~/Downloads/sand-valley-2026.html` inside `.nav-links` (around line 614):

```html
<a href="scoreboard/">The Cup</a>
```

Then redeploy the itinerary with `./scripts/deploy.sh "Add Cup scoreboard link"`.
(Left out of this change set on purpose — the itinerary landing page is only
edited with a go-ahead.)

---

## 7. Recreate from scratch

If the file is ever lost, this prompt rebuilds it:

> Build a single self-contained HTML scoreboard page for "The Sand Valley Cup," a
> Ryder Cup style golf trip (July 8-12, 2026, 8 golfers, 7 sessions, first to 9.5
> of 18 points). Match this design system: paper background `#fbf8f1`, ink
> `#1c1b18`, Young Guns green `#3f7a4e`, Old Guard navy `#2f5d7c`, gold accent
> `#c89321`; Cormorant Garamond for headings and big numbers, Inter for body and
> data with tabular numerals. Sections: sticky live tally bar; hero with countdown
> to first tee; a Cup Meter tug-of-war bar toward a 9.5 clinch line with a
> per-session rail; 7 tappable session cards; a sortable individual race table
> (Thru, Gross with to-par, Net with to-par) where lowest net leads and crowns
> Player of the Week, plus a Daily MVP; a skins game with pot/won/carrying stats and a per-player
> winnings bar chart ranked by dollars with skins counts; and team rosters with
> captain badges. Drive everything from one editable DATA block so scores can be
> updated by hand each night. Use the teams, indexes, sessions, and scoring rules
> in this README.

---

*Private project for the Sand Valley Cup. Do not share publicly.*

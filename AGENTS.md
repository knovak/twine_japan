# twine_japan Authoring Guide

This repository houses multiple travel-guide microsites built with **Twine** (via Tweego) and published as static HTML decks. Follow the instructions below whenever you add or modify content.

## Repository layout and build pipeline
- Author each site inside `stories/<site-name>/` using Tweego-compatible `.twee` sources. Every site directory must contain:
  - `00_meta.twee` with the `StoryTitle`, `StoryData` (SugarCube 2.36.1), shared stylesheet imports, and any boot-time JavaScript injection.
  - `01_passages/` with the individual passage `.twee` files that make up the interactive deck.
  - `assets/` for deck-specific static files. Place CSS in `assets/styles.css`, optional JavaScript helpers in `assets/scripts.js`, and supporting media (images, etc.) under `assets/images/`.
- Shared widgets live under `shared/`. They are automatically included by `scripts/build.sh` when Tweego compiles each deck.
- Run `scripts/get_tweego.sh` once per machine to download the Tweego binary into `.bin/`. Then run `scripts/build.sh` to compile **every** site into `dist/`. The script copies each deck's assets, injects the PWA service-worker registration snippet, and regenerates the root index that links to all compiled decks.
- GitHub Actions mirrors the local workflow:
  - `.github/workflows/pages.yml` installs Tweego, runs `scripts/build.sh`, and publishes the generated `dist/` output to the `gh-pages` branch on every push. Non-`main` branches receive a `z_staging_` prefix so previews stay isolated.
  - `.github/workflows/gh-pages-deploy.yml` deploys the refreshed `gh-pages` branch to GitHub Pages. Do not hand-edit the `gh-pages` branch; it is rebuilt automatically.

## Pattern for creating new sites in parallel
- Treat `stories/nikko1` as the canonical example. When adding a new destination, copy its layout (meta file, passage folder, assets folder) into a new directory like `stories/<new-site>/` and update the metadata, CSS, and passages accordingly.
- Keep filenames descriptive and kebab-cased (`lake-kirikomi-loop.twee`). Each passage title should match the link text for clarity.
- Do not use ampersand character in the file names or the card titles.  If appropriate, spell the word "and" instead of using "&".
- Reuse shared conventions:
  - Create a “Table of Contents” passage that acts as the starting entry, categorizing content (e.g., Attractions, Hotels, Transport, Hikes) into grid cards that link to individual passages.
  - Within passages, wrap the main content in `.card` markup with `card-number`, `card-header`, `card-content`, and `.navigation` links, mirroring the Nikko site.
  - Use `.highlight` blocks for key callouts (hours, fees, fun facts) and the collapsible `.location-section` for address/mapping information. These styles and behaviors are defined in `assets/styles.css` and `assets/scripts.js` respectively.
  - Provide navigation links back to the Table of Contents and onward to related cards to maintain traversal flow.
- Store deck-specific imagery under `assets/images/` and reference them using relative paths inside passages. When practical, prefer checked-in assets over hotlinking external images.

## Styling and scripting conventions
- `stories/nikko1/assets/styles.css` demonstrates the expected layering: it aggressively resets SugarCube defaults, defines the card layout, grid-based table of contents, highlight callouts, and location toggles. New sites should either reuse this stylesheet or adapt it thoughtfully; keep overrides near the end to win against SugarCube’s cascade.
- `stories/nikko1/assets/scripts.js` exposes `toggleLocation()` for collapsing and expanding location details. If you add new interactive helpers, place them in `assets/scripts.js` and ensure `00_meta.twee` appends the script tag using the same pattern (`Story JavaScript` passage injecting `assets/scripts.js`).

## Content structure expectations (based on `nikko1`)
- Group cards into logical sections (Attractions, Hotels, Transport, Hikes, etc.) on the Table of Contents. Each section’s cards should provide a short description beneath the link to encourage exploration.
- Individual cards typically include:
  - Card header with Japanese and English titles plus a sequential `card-number`.
  - Hero imagery (`.temple-image`) followed by collapsible location info (address in Japanese and English plus Google Maps link).
  - One or more `.highlight` callouts emphasizing visiting tips, hours, admission fees, or notable facts.
  - Narrative paragraphs giving historical context, cultural insights, and travel guidance.
  - Outbound resources (e.g., Wikipedia link) styled with `.wikipedia-link`.
  - `.navigation` links that weave the passage back into the broader itinerary.
- Hike passages follow the same template but focus highlights on trail stats, elevation, and required logistics, and provide a link to another site like alltrails.com for more info
- Transport passages emphasize schedules and connectivity.

By following these patterns you can introduce additional regional guides without interfering with existing ones. Always run the build script before committing so that automated workflows—and eventual GitHub Pages deployments—remain in sync with your changes.

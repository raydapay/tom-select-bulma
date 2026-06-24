# AGENTS.md — tom-select-bulma

Guidance for AI coding agents. Read this before changing anything. It captures what the
code **doesn't** tell you; for usage see `README.md`, for the strategy see the header comment
in `src/tom-select.bulma.scss`.

## What this is

A **Bulma theme for [Tom Select](https://tom-select.js.org)** — pure CSS, no JS. One SCSS
source compiles to a self-contained stylesheet (Tom Select's base structure + a Bulma skin)
that tracks Bulma's light/dark themes and RTL automatically.

## Mental model (the one thing to understand)

The theme feeds Bulma's **runtime CSS custom properties** (`var(--bulma-*)`) into Tom Select's
**`!default` SCSS variables**, then `@import`s Tom Select's base. So the compiled rules reference
Bulma tokens directly → colours follow `data-theme="dark"` with no extra rules.

⚠️ **The landmine:** exactly **four** Tom Select colour variables are passed through Sass colour
functions (`color.adjust` / `color.change`) in its base/partials, so they **cannot** hold a
`var()` string or the build fails:

- `$select-color-text`
- `$select-color-item`
- `$select-color-item-text`
- `$select-color-item-border`

These stay **real hex colours** (Bulma-light values, used only as no-Bulma fallback) and are
re-skinned for dark mode in the integration layer at the bottom of the SCSS. **Every other**
colour var takes `var(--bulma-*, <fallback>)` directly. If you add a colour and the build errors
with "argument must be a color", you hit this — move that surface to the integration layer instead.

## Layout

```
src/tom-select.bulma.scss   the ONLY file you edit (vars + @import base + integration layer)
dist/*.css                  compiled output — COMMITTED; rebuild before committing changes
docs/index.html             live demo gallery (GitHub Pages); docs/*.css is a built copy
scripts/screenshots.sh      regenerates README/demo screenshots (headless Chromium)
```

## Build & verify loop

```bash
npm install            # sass + tom-select + bulma (dev only)
npm run dist           # builds dist/*.css (+ .min) AND docs/tom-select.bulma.css
npm run screenshots    # regenerates the 4 screenshots (auto-installs an Arabic font if missing)
```

**Verifying a visual change** (there is no unit test — verification is visual):
- Render with headless Chromium and look. `scripts/screenshots.sh` is the reference for how.
- Check **both light and dark** (`data-theme="dark"`), and **LTR + RTL** (`dir="rtl"`) for any
  direction-dependent change. A change that passes only one theme/direction is not done.

## Hard rules

1. **No hardcoded colours** except: the four Sass-function vars above, and fallback values inside
   `var(--bulma-x, <fallback>)`. Everything visible must resolve to a Bulma token so dark mode works.
2. **Logical properties for anything directional** — `padding-inline-start`, `inset-inline-end`,
   `border-start-end-radius`, etc. Never physical `left`/`right`/`padding-left` in new rules. This is
   why RTL "just works"; don't regress it.
3. **`dist/` is committed.** Run `npm run dist` and stage the rebuilt CSS in the same commit as a
   source change, or the published CDN/tag goes stale.
4. **Don't make `has-icons-left/right` logical.** They are intentionally physical to match the
   *currently released* Bulma (which positions the icon physically). Making our padding logical while
   Bulma's icon stays physical puts them on opposite sides in RTL. The logical option already exists
   as the separate `has-icons-start` / `has-icons-end` classes — use/extend those instead.
5. **Never commit `node_modules/`** (gitignored) and keep secrets/PII out (commits use a GitHub
   noreply email by design).
6. **Update `CHANGELOG.md` on every change that affects the compiled CSS or public behaviour.**
   Add a bullet under the `## [Unreleased]` heading (in the right `Added` / `Changed` / `Fixed`
   group), in the **same commit** as the change. Docs-only or internal-tooling changes are exempt.
   When cutting a release, rename `[Unreleased]` to the new version + date and add a fresh empty
   `[Unreleased]`.

CI (`.github/workflows/ci.yml`) runs `npm ci && npm run dist` and **fails if committed CSS is stale**
— so rule #3 is enforced automatically on every push/PR. Run `npm run dist` before committing.

## Common tasks

- **Add/adjust a colour state:** edit the `$ts-bulma-colors` list (quoted strings) — the `@each`
  loop generates border + focus-ring rules. Only works for colours Bulma exposes as `--bulma-<name>`
  and `--bulma-<name>-h/s/l`.
- **Add a Bulma modifier (size/state/etc.):** add a rule in the integration layer using
  `var(--bulma-*)`; mirror an existing one. Add an example to `docs/index.html` and re-run
  `npm run screenshots`.
- **Change spacing/metrics:** prefer the `$select-*` variable overrides at the top (em-based) so
  sizes scale; the base consumes them.
- **Cut a release:** move `[Unreleased]` notes to a new `vX.Y.Z` section in `CHANGELOG.md` →
  `npm run dist` → commit → `git tag -a vX.Y.Z` → `git push --tags` → `gh release create`.
  jsDelivr serves from the tag immediately; cdnjs autoupdates from tags.

## Upstream relationship

This theme is a downstream consumer of Bulma + Tom Select; it is **not affiliated** with either.
While building it we found and reported RTL bugs in Bulma (physical props that should be logical):
- `jgthms/bulma#4029` (menu) — fix PR `jgthms/bulma#4048`
- `jgthms/bulma#3981` (has-icons) — comment with proposed fix; awaiting maintainer

If you touch RTL/logical-property behaviour, check whether it relates to these.

## Distribution

Deliberately **not on npm** (privacy). Distributed via: jsDelivr from the GitHub tag
(`cdn.jsdelivr.net/gh/raydapay/tom-select-bulma@<tag>/...`), `npm i github:raydapay/tom-select-bulma#<tag>`
for bundlers, and a pending cdnjs entry (`cdnjs/packages#2172`). Don't add an `npm publish` step
without being asked.

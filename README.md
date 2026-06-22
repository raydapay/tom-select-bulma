# tom-select.bulma

### ▶ [Live demo &amp; example gallery](https://raydapay.github.io/tom-select-bulma/)

A [Bulma](https://bulma.io) theme for [Tom Select](https://tom-select.js.org) — the
lightweight, framework-agnostic select/autocomplete/tagging widget. Gives you Tom Select's
search, multi-select, remote loading and create-on-the-fly while looking like a native Bulma
control, **including automatic light/dark theme support** via Bulma's CSS variables.

Tom Select ships `default`, `bootstrap4` and `bootstrap5` themes — but no Bulma one. This is that
missing theme.

| Light | Dark |
| --- | --- |
| ![light mode](docs/screenshot-light.png) | ![dark mode](docs/screenshot-dark.png) |

## Why a theme, not a fork

Tom Select is almost entirely *behaviour* — keyboard navigation, ARIA accessibility, remote
loading, tagging, plugins. Its styling is a thin SCSS layer with `!default` variables, exactly the
way the Bootstrap themes are built. So this is a **theme**, not a reimplementation: you keep every
Tom Select feature and bugfix, and only the appearance changes.

## How it works

The theme feeds Bulma's runtime CSS custom properties (`var(--bulma-*)`) straight into Tom Select's
own `!default` SCSS variables, then layers on the pieces the base doesn't parametrise (focus ring,
size/colour modifiers, icon slots, loading spinner, tag-styled chips). Because the colours resolve
to Bulma tokens at runtime, the control follows Bulma's `data-theme="dark"` toggle with **no
hardcoded colours** — every colour has a `var(--bulma-*)` with a Bulma-light fallback so it still
degrades gracefully if Bulma is absent.

## Install

```bash
npm install   # installs sass + tom-select + bulma (dev)
npm run dist  # builds dist/tom-select.bulma.css and .min.css
```

## Usage

Load Bulma, **this theme instead of `tom-select.css`** (it's self-contained — base + skin), and
Tom Select's JS:

```html
<link rel="stylesheet" href="bulma.min.css" />
<link rel="stylesheet" href="tom-select.bulma.css" />
<script src="tom-select.complete.min.js"></script>

<select id="framework" placeholder="Pick a framework…">
  <option value="">Pick a framework…</option>
  <option value="flask">Flask</option>
  <option value="django">Django</option>
</select>

<script>
  new TomSelect('#framework', {});
</script>
```

> Do **not** also load `tom-select.css` / `tom-select.default.css` — this theme already includes
> the base structure.

## Supported Bulma modifiers

Put Bulma's usual classes on the original `<select>` (Tom Select copies them onto the wrapper):

| Feature        | How                                                                                  |
| -------------- | ------------------------------------------------------------------------------------ |
| Sizes          | `class="is-small \| is-medium \| is-large"`                                          |
| Colour states  | `class="is-primary \| is-link \| is-info \| is-success \| is-warning \| is-danger"`  |
| Rounded        | `class="is-rounded"`                                                                  |
| Loading        | `class="is-loading"` on the wrapper (also responds to Tom Select's own `.loading`)   |
| Left/right icon | wrap in `<div class="control has-icons-left">` + `<span class="icon is-left">`      |
| Multi-select   | native `multiple` attr — chips render as Bulma tags; add the `remove_button` plugin   |
| Validation     | an invalid bound `<select>` gets Tom Select's `.invalid` → rendered as `is-danger`    |

## Dark mode

Nothing to configure. Toggle Bulma's theme as usual and the control follows:

```js
document.documentElement.setAttribute('data-theme', 'dark');
```

## Right-to-left (RTL)

Set `dir="rtl"` on a container (or the page) and everything flips — Tom Select adds its own
`.rtl` class automatically, and this theme uses CSS **logical properties** so the `has-addons`
corner-squaring and the loading spinner mirror correctly. Text alignment and the chip remove (`×`)
follow suit.

| RTL · Light | RTL · Dark |
| --- | --- |
| ![rtl light](docs/screenshot-rtl-light.png) | ![rtl dark](docs/screenshot-rtl-dark.png) |

> `has-icons-left` / `has-icons-right` are **physical** by Bulma's own convention — a left icon
> stays on the left in RTL. Pick the side you want; the control's padding follows the icon either
> way.

## Live demo

**→ https://raydapay.github.io/tom-select-bulma/**

The full example gallery — single / multi / option groups / tagging / remote / custom
rendering / icons / sizes / colours / loading, with a light–dark–auto theme switcher. The source
is [`docs/index.html`](docs/index.html); open it in a browser (it loads Bulma and Tom Select from a
CDN), or serve it locally:

```bash
npm run build:docs           # compile the theme into docs/
npx serve docs               # or any static server, then open the printed URL
```

### Hosting it on GitHub Pages

This site is published from the `docs/` folder via GitHub Pages (**Settings → Pages**, source
**`main` / `docs`**); every push to `main` that touches `docs/` redeploys it. Note GitHub Pages on
a **private** repo requires a paid plan (Pro/Team/Enterprise) — on a free account the repo must be
public.

## Project layout

```
src/tom-select.bulma.scss   the theme source (the only file you edit)
dist/tom-select.bulma.css   compiled, distributable CSS (+ .min.css)
docs/index.html             the live example gallery (GitHub Pages source)
docs/tom-select.bulma.css   compiled copy the demo loads
```

## Compared to the official Bootstrap 5 theme

Tom Select's `bootstrap5` theme is the closest reference point. This theme aims for parity on
everything that maps to a Bulma idiom, and goes further where Bulma offers more:

| Feature | `bootstrap5` | `tom-select.bulma` | Notes |
| --- | :---: | :---: | --- |
| Core skin (colour / border / radius / padding) | ✓ | ✓ | We derive ours from `var(--bulma-*)`. |
| **Dark mode** | ✗ | ✓ | BS5 is light-only unless you wire up Bootstrap's dark vars; ours follows `data-theme="dark"` automatically. |
| Focus ring | ✓ | ✓ | |
| Placeholder, transitions, shadow | ✓ | ✓ | |
| Multi-select chips + `remove_button` | ✓ | ✓ | Ours render as Bulma tags. |
| Sizes | sm, lg | small, **medium**, large | Bootstrap only has two sizes. |
| Colour states | invalid / valid | all six `is-*` + `.invalid` | |
| Disabled | ✓ | ✓ | |
| Option-group headers + divider | ✓ | ✓ | |
| `has-addons` / `input-group` grouping | ✓ | ✓ | Inner corners square up against the neighbour. |
| Left / right **icon slots** | ✗ | ✓ | `has-icons-left` — not a Bootstrap idiom. |
| **`is-loading` spinner** | ✗ | ✓ | Bulma-style ring on the control. |
| Validation ✓/✗ **SVG icons**, `was-validated` | ✓ | — | N/A by design: Bulma signals validity with a coloured border (+ optional `help` text), which the `is-*` / `.invalid` states already cover. |
| `form-control` vs `form-select` split | ✓ | — | N/A: Bulma has no two-class split for inputs vs selects. |

The dash (`—`) rows are **not gaps** — they are Bootstrap-specific conventions with no Bulma
equivalent, so reproducing them would look foreign in a Bulma page.

## Notes / limitations

- Built against **Bulma 1.0** (CSS-variable era) and **Tom Select v2**.
- A right-side icon (`has-icons-right`) overlaps the single-select caret; prefer left icons, or use a
  multi-select where there is no caret.
- The `dropdown_header` plugin's divider uses a CSS function the upstream SCSS emits in a non-standard
  form; the header still works, only that one divider tint may be unset.

## License

MIT.

# Decisions — Bulma modifier coverage

A protocol of which Bulma form modifiers this theme supports and **why**. Scope: every
`is-*` / `has-*` modifier Bulma applies to `.input` / `.select` / `.control` / `.field`
(enumerated from `bulma@1.0.4`). Re-run the audit with:

```bash
grep -oE "\.(input|select|control|field)\.(is|has)-[a-z-]+" node_modules/bulma/css/bulma.min.css | sort -u
```

## Implemented in the theme (we emit CSS for these)

| Modifier | Why |
| --- | --- |
| Colour states `is-white`…`is-danger` (all 11) | Bulma applies the full set to `.select`; we mirror it as a coloured border + focus ring (the dominant signal on a control). |
| `is-small` / `is-medium` / `is-large` | Bulma sizes; we scale via `font-size` so the em-based metrics follow. |
| `is-rounded` | Bulma modifier. |
| `is-fullwidth` | Bulma applies it to `.select`; added in v0.2.0. |
| `is-loading` (on the wrapper) | Bulma-style spinner on `.ts-wrapper`, mirrored with logical positioning for RTL. |
| `has-icons-left` / `has-icons-right` | Physical, **matching Bulma exactly** (Bulma positions the icon physically). |
| `has-icons-start` / `has-icons-end` | **Our addition** (not in Bulma): logical, RTL-aware. A forward-port of jgthms/bulma#3981. |
| `has-addons` | Square inner corners + `is-expanded` growth + focus `z-index`, so the control joins a neighbour flush. |
| `.invalid` (Tom Select state) | Rendered as Bulma `is-danger`. |

## Works natively via Bulma — no theme code needed (verified)

| Modifier | Why it just works |
| --- | --- |
| `.control.is-loading` | Bulma's `.control.is-loading::after` renders on the `.control`, which wraps our control. (Use `is-loading` on the **wrapper** for our Bulma-token spinner; both are fine.) |
| `.field.is-grouped` (+ `-centered` / `-right` / `-multiline`) | Pure flex layout on `.field`; our `.ts-wrapper` is just a flex item inside a `.control`. |
| `.field.is-horizontal` (`field-label` / `field-body`) | Layout only; our control sits in `field-body`. |
| `.field.has-addons-centered` / `-right` | `justify-content` on the field; same family as `has-addons`. |
| Generic helpers (`m-*`, `p-*`, etc.) | Element-agnostic; apply to any element. |

## Skipped — deliberately not implemented

| Modifier | Reason |
| --- | --- |
| `is-static` | Bulma applies it only to `.input` (text inputs), **not** `.select`. A borderless static-text display contradicts an interactive combobox. Adding it would be inventing non-Bulma API. |
| `.select.is-disabled` (manual class) | Tom Select's real disabled path is the `disabled` **attribute** → `.ts-wrapper.disabled`, which we style. A CSS-only `is-disabled` wouldn't actually disable the interactive widget, so we don't restyle it — use the attribute. |
| `has-background-*` / `has-text-*` helpers | Target the hidden native `<select>` or set raw text styling; not meaningful for the rendered control, and not how Bulma styles form controls. |

## N/A — not in Bulma 1.0

| Modifier | Note |
| --- | --- |
| `is-focused` / `is-hovered` / `is-active` | Force-state modifiers were removed after Bulma 0.9. Use real `:focus` / `:hover`; Tom Select adds its own `.focus` class, which we style. |

## Conclusion

Coverage is **complete** for Bulma 1.0 form modifiers: everything is either implemented,
works natively, is input-only (N/A to selects), or was removed from Bulma. Before adding a new
modifier, confirm Bulma actually applies it to `.select`/`.control`/`.field` — if it doesn't,
default to **skip** and record the reason here.

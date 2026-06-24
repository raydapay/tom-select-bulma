# Changelog

All notable changes to this project are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow [SemVer](https://semver.org/).

## [Unreleased]

### Added
- `is-fullwidth` modifier (mirrors Bulma's `.select.is-fullwidth`).

## [0.1.0] — 2026-06-22

First release.

### Added
- Bulma theme for Tom Select: imports Tom Select's base and binds it to Bulma's
  runtime CSS variables, so the control looks native in Bulma.
- Automatic light/dark theming via `data-theme` (no hardcoded colours).
- All 11 Bulma input colour states (`is-white`…`is-danger`) plus `.invalid`.
- Sizes (`is-small`/`is-medium`/`is-large`), `is-rounded`, `is-loading` spinner.
- Multi-select chips styled as Bulma tags; `has-addons` grouping.
- Icon slots: physical `has-icons-left`/`has-icons-right` and logical
  `has-icons-start`/`has-icons-end` (RTL-aware).
- Full RTL support via CSS logical properties.
- Demo gallery (GitHub Pages) and reproducible screenshot script.

[Unreleased]: https://github.com/raydapay/tom-select-bulma/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/raydapay/tom-select-bulma/releases/tag/v0.1.0

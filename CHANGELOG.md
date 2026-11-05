# Changelog

## Unreleased

- Removed the TTS button. Browser speech synthesis remains behind the scenes
  but has no UI until a good free voice model is selected.
- Removed all interactive yellow highlights from the widget chrome; the face
  remains `#FFBF00`.
- Added soft masked blur at the top and bottom of the chat scroll area, with
  scroll-aware visibility and a gradient fallback.
- Switched the demo workbench accent to white.

## 2.0.0 — 2026-11-05

- Extracted Sprite from beben.design into a standalone public project.
- Rebuilt the widget to the Figma pill and panel exports.
- Replaced the CSS-art face with an SVG face: yellow circle, two vertical pill
  eyes and a minimal mouth.
- Added the central `SpriteEmotion` controller with priorities, temporary and
  persistent states, idle detection, sleeping and waking.
- Added all twelve expressions and one-shot bounce, blink and look-around
  animations.
- Added reduced-motion and page-visibility handling.
- Added a development playground and public demo.
- Added the Worker emotion tag: replies now return `{ reply, emotion }`.
- Added MIT licence.

## Pre-2.0

- The previous widget lived in `beben.design/docs/assets/JS/sprite.js`.

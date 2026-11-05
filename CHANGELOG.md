# Changelog

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

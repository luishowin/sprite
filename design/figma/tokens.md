# Figma exports

These files are the flattened design references supplied for the 2.0 face and
widget overhaul:

- `pill.svg` — collapsed launcher, 337 × 57
- `long-lines.svg` — panel with long answers, 457 × 664
- `short-lines.svg` — panel with short answers, 457 × 543

The text in the exports is outlined, so the production component rebuilds the
UI in semantic HTML/CSS and uses the SVG geometry only as a visual spec.

## Palette

| Use | Value |
| --- | --- |
| Panel | `#0C0C0C` |
| Pill / header bar / input | `#000000` |
| Sprite bubble | `#212121` |
| User bubble | `#424242` |
| Border | `#2A2A2A` |
| Face | `#FFBF00` |
| Ink | `#000000` |
| Online | `#27C45E` |
| Placeholder | `#666666` |

## Measures

| Element | Value |
| --- | --- |
| Pill height | 57 |
| Pill radius | 28.33 |
| Panel radius | 33 |
| Header bar height | 56.66 |
| Header bar radius | 28.33 |
| Avatar diameter | 36.4 |
| Bubble radius | 14 (one 3px tail corner) |
| Input radius | 28 empty / 20 multiline |
| Type | IBM Plex Mono |

## Face

The production face uses a 100 × 100 viewBox:

- head circle, radius 49.5, centre 50/50
- two rounded rectangles, 11.3 × 28.6, corners 5.65
- eye centres at 38/42 and 62/42
- mouth path `M -8 0 Q 0 5.5 8 0`, round caps

The pill export has shorter eyes. The panel exports use taller eyes. The
standalone sprite uses the taller panel proportions so the vertical pill shape
is unmistakable at 36px, with the pill's centred upright pose as neutral.

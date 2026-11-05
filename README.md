# Sprite

Sprite is a small, expressive yellow character who guides visitors around a
site. This repository is the standalone home of her face, motion system, chat
widget and Cloudflare proxy. It is the source of truth; the copy at
[beben.design](https://beben.design) is a vendored build.

- No framework
- No runtime dependencies
- One `sprite.css` and one `sprite.js`
- SVG face, CSS transforms, small amount of vanilla JavaScript
- Twelve expressions, idle behaviour, blinking, sleeping and reduced-motion support

## Demo

Open `index.html` directly or run a local server:

```bash
python3 -m http.server 8130
# http://127.0.0.1:8130/
```

The demo is the character workbench. It contains the twelve-state sheet, the
live widget, animation playback, idle timing controls, reduced-motion emulation
and the independent eye and mouth geometry sliders.

The demo runs offline. It sets `apiUrl` to an empty string before loading the
widget. The real site points the same file at its Worker.

## Quick start

```html
<link rel="stylesheet" href="sprite.css">
<script src="sprite.js"></script>
```

That is enough. The widget injects its own DOM and starts in its neutral state.
Do not add markup to the host page.

To use the live brain, define the configuration before the script:

```html
<script>
  window.SPRITE_CONFIG = {
    apiUrl: 'https://your-worker.example.workers.dev',
    maxHistory: 12
  };
</script>
<script src="sprite.js"></script>
```

`SPRITE_CONFIG` defaults to the Beben proxy. Set `apiUrl` to `''` for a fully
offline, pattern-matching Sprite.

## Design

The visual language comes from the Figma exports in `design/figma/`:

| Token | Value |
| --- | --- |
| Panel | `#0C0C0C` |
| Panel bar / input | `#000000` |
| Sprite bubble | `#212121` |
| User bubble | `#424242` |
| Border | `#2A2A2A` |
| Face | `#FFBF00` |
| Ink | `#000000` |
| Online | `#27C45E` |
| Type | IBM Plex Mono |
| Panel | 457 × 664, 33px radius |
| Pill | 57px high, 999px radius |
| Avatar | 36px |

The face is deliberately simple: one circular head, two vertical pill eyes and
one small mouth. There is no nose, hair, body or permanent eyebrow. Expression
comes from eye height, width, position, rotation and opacity, plus the mouth
curve and a little body movement.

The eye geometry is controlled by CSS custom properties. Each eye can be moved
and scaled independently. The mouth uses one curved SVG path; negative vertical
scale turns the smile into a frown.

## Emotion API

```js
SpriteEmotion.setEmotion('excited', { duration: 1800 });
```

Options:

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `duration` | number | emotion default | Temporary state in milliseconds |
| `priority` | number | emotion default | Higher values interrupt lower values |
| `persistent` | boolean | emotion default | Set the new resting state |
| `force` | boolean | `false` | Ignore the current priority |
| `immediate` | boolean | `false` | Skip the transition |

Supported identifiers:

`neutral`, `looking-around`, `excited`, `happy`, `smug-proud`, `smiling`,
`sad`, `suspicious`, `confused`, `curious`, `unimpressed`, `sleeping`.

Legacy names are aliased: `idle`, `waving`, `dancing`, `surprised`, `thinking`,
`guessing`, `bored`, `angry` and `talking`.

Other controller methods:

```js
SpriteEmotion.reset();                 // back to neutral
SpriteEmotion.wake();                  // leave the sleeping state
SpriteEmotion.sleep();                 // sleep now
SpriteEmotion.touch();                 // register visitor activity
SpriteEmotion.playBlink({ double: true });
SpriteEmotion.playLookAround();
SpriteEmotion.setReducedMotion(true);  // null returns to the system setting
SpriteEmotion.configure({ sleepAfter: 10000 });
SpriteEmotion.getState();
SpriteEmotion.onChange(fn);            // returns an unsubscribe function
```

`SpriteChat` exposes convenience wrappers:

```js
SpriteChat.setEmotion('happy', { duration: 2000 });
SpriteChat.react('smug-proud');
SpriteChat.wake();
SpriteChat.sleep();
SpriteChat.getEmotion();
```

### Events

Any part of the page can ask Sprite to react without importing anything:

```js
document.dispatchEvent(new CustomEvent('sprite:emotion', {
  detail: { emotion: 'excited', duration: 2200 }
}));
```

That is the intended integration point for a successful form submission, a
completed tool action or a game win.

## Behaviour

- Neutral is the resting state.
- Blinking is randomised at roughly 4–7 second intervals, with occasional
  double blinks.
- After 5–10 seconds of inactivity Sprite occasionally looks around.
- After 60 seconds she sleeps.
- Any pointer, key, focus, scroll or chat interaction wakes her and resets the
  inactivity clock.
- Idle behaviour is held off while the chat panel is open or a reply is being
  generated.
- A higher-priority conversational reaction interrupts an idle look.
- `prefers-reduced-motion` stops blinking, looking around, bounce and breathing.
- Timers and CSS animations pause when the page is hidden.

All timings live in the `TIMINGS` object inside `SpriteEmotion`, or can be
overridden with `window.SPRITE_CONFIG.idle`.

## Conversational integration

The offline fallback maps dialogue intent to expressions. The live Worker asks
the model for a hidden emotion tag and returns it as a validated `emotion`
field. If an older Worker is deployed, the widget still works and falls back to
`smiling`.

The conversational targets are:

| Signal | Expression |
| --- | --- |
| Visitor achieves something | `excited` |
| Sprite helps complete a task | `happy` |
| Visitor admits Sprite was right | `smug-proud` |
| Friendly interaction | `smiling` |
| Clearly hostile interaction | `sad` |
| Cheeky remark | `suspicious` |
| Illogical statement | `confused` |
| Obscure or unusual question | `curious` |
| Bad joke | `unimpressed` |
| Prolonged inactivity | `sleeping` |

Disagreement, correction and constructive criticism are deliberately not
treated as hostility.

## Adding an expression

Add one entry to `EMOTIONS` in `sprite.js`:

```js
'my-expression': {
  priority: 14,
  duration: 3000,
  head: -2,                       // degrees
  eyes: {
    left:  { x: 0, y: 0, w: 1,   h: 0.9, rot: -4, opacity: 1 },
    right: { x: 1, y: -1, w: 1.1, h: 1.1, rot: 4, opacity: 1 }
  },
  mouth: { x: 1, y: 0, w: 0.7, h: 0.5, rot: -4, stroke: 2.6, opacity: 1 }
}
```

Then add the name to the allowlist in `worker/sprite-proxy.js` if the live
brain should be able to choose it. The demo builds its state sheet and buttons
from `SpriteEmotion.emotions`, so the new expression appears automatically.

If the expression needs a one-shot movement, add a reaction class in
`sprite.js` and a matching keyframe in `sprite.css`.

## Worker

`worker/sprite-proxy.js` is a Cloudflare Worker that holds the Fireworks API
key. It is not part of the browser bundle. See `worker/README.md` for the
deployment steps. Changing the Worker requires a redeploy in the Cloudflare
dashboard; it does not deploy from git.

## Syncing into beben.design

The website vendors `sprite.js` and `sprite.css` under `docs/assets`. The two
files here are canonical. From this repository:

```bash
tools/sync-to-site.sh /path/to/beben.design 8.0
```

The script copies both files and updates the version query string in the site's
HTML and templates. Review and test the site afterwards.

## Project layout

```text
sprite.js                 widget, controller, offline dialogue engine
sprite.css                face, widget chrome, responsive and motion rules
index.html                public demo and development playground
demo/playground.js        workbench logic
demo/fonts/               IBM Plex Mono for the demo
design/figma/             source exports and token notes
worker/sprite-proxy.js    Cloudflare Worker
tools/sync-to-site.sh     vendoring helper
```

## License

MIT. See `LICENSE`.

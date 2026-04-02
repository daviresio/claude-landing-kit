# Frontend Design System

Gives Claude a design philosophy and system before touching any code. Breaks the "distributional convergence" trap — the tendency to produce Inter font + purple gradient + grid cards every time.

This skill is invoked automatically by `/landing`. You rarely need to call it directly.

---

## The Problem This Solves

LLMs default to the statistical center of design decisions seen in training data. That center looks like:
- Font: Inter (always)
- Color: purple or blue gradient on white
- Layout: symmetric grid cards
- Animation: fade-in on mount, nothing else
- Buttons: rounded, solid primary color

The result is functional but instantly recognizable as AI-generated. This skill breaks that pattern.

---

## Design Philosophy (apply before writing any component)

### 1. Choose a visual identity first — not a color

Before picking colors, establish the **mood**:
- **Minimal / Editorial**: large whitespace, one accent, serif headlines, monochrome base
- **Bold / Expressive**: strong contrast, oversized type, asymmetric layout, textured backgrounds
- **Soft / Friendly**: rounded everything, warm neutrals, soft shadows, playful spacing
- **Dark / Premium**: near-black background, gold or cyan accent, glass morphism, blur effects
- **Brutalist / Structural**: visible grid, strong borders, uppercase type, flat design

Pick one. Design every decision from it. Never mix.

### 2. Typography first

Type is 80% of design. Pick a distinctive pairing:

| Mood | Display | Body |
|------|---------|------|
| Editorial | Playfair Display | DM Sans |
| Bold | Space Grotesk | Inter |
| Soft | Nunito | Nunito Sans |
| Premium dark | Syne | Manrope |
| Brutalist | Bebas Neue | IBM Plex Mono |
| Modern SaaS | Bricolage Grotesque | Geist |

**Never use:** Inter for both display and body (it's the default, avoid it).

### 3. Spacing: go bigger than you think

Cramped UI = amateur UI. Default padding should feel almost excessive:
- Section vertical padding: `py-24 md:py-36` (not `py-16`)
- Card internal padding: `p-8 md:p-10` (not `p-4`)
- Between headline and subheadline: `mb-6` minimum
- Max content width: `max-w-5xl` for copy-heavy, `max-w-7xl` for visual

### 4. Color: one accent, used intentionally

Pick ONE accent color and use it in max 3 places:
1. Primary CTA button
2. Highlighted text or badge
3. Icon or decorative element

**Do not:** spread the accent across borders, backgrounds, icons, and buttons simultaneously.

**Background strategy** (pick one):
- Pure white with near-black text (clean)
- Off-white `#FAFAF8` with warm dark `#1A1A1A` (softer)
- Near-black `#0A0A0F` with off-white text (premium dark)
- Colored background section as contrast break (e.g., dark section between light sections)

### 5. Avoid these specific defaults

| ❌ Avoid | ✅ Instead |
|---------|----------|
| Purple-to-blue gradient hero | Solid background + graphic element OR dark section |
| White cards with gray border | Cards with subtle background shift (`bg-muted/40`) OR no card container |
| 6-column feature grid | 3 large features OR alternating horizontal layout |
| Centered everything | Mix: centered hero, left-aligned features |
| Fade-in-on-scroll on everything | Selective animation — 2-3 elements max per section |
| Stock-photo hero image | Abstract graphic, screenshot of product, or no image |
| Badge above every section heading | Use badge sparingly — hero and maybe one other section |

### 6. Make one section dramatically different

The page needs a visual break. Choose one:
- **Dark section** amid light sections (pricing or social proof)
- **Full-width color block** for the CTA section
- **Oversized typography** section (one stat or quote at 96px+)
- **Horizontal scroll** for logos or testimonials

---

## Typography Tokens (update `globals.css` and `tokens.ts`)

```css
/* globals.css — example: Bold SaaS mood */
@import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;450;500&display=swap');

:root {
  --font-display: 'Space Grotesk', sans-serif;
  --font-body: 'Inter', sans-serif;
}
```

```ts
// tokens.ts additions
typography: {
  displayXl:  "font-display text-6xl md:text-7xl lg:text-8xl font-bold tracking-tight leading-[0.95]",
  displayLg:  "font-display text-4xl md:text-5xl lg:text-6xl font-bold tracking-tight leading-[1.0]",
  displayMd:  "font-display text-3xl md:text-4xl font-semibold tracking-tight",
  heading:    "font-display text-2xl md:text-3xl font-semibold",
  subheading: "font-body text-lg md:text-xl text-muted-foreground leading-relaxed",
  body:       "font-body text-base leading-relaxed",
  label:      "font-body text-sm font-medium uppercase tracking-widest",
},
```

---

## Animation: less is more

**Rule**: max 3 animated elements per viewport. Everything else is static.

**Good animation choices** (pick 1-2 per page, not all):
```tsx
// Subtle entrance — use on hero headline only
initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}

// Staggered cards — use on one section only
transition={{ delay: index * 0.08, duration: 0.4 }}

// Smooth counter — use on stats section
// (use framer-motion's useMotionValue + useSpring)

// Gradient text animation — use on hero keyword only
className="animate-gradient bg-gradient-to-r from-primary via-accent to-primary bg-[200%_auto] bg-clip-text text-transparent"
```

**Avoid**: applying `whileInView` fadeUp to every single `<div>`. It looks like a template.

---

## Layout patterns that feel designed (not templated)

### Hero: asymmetric or oversized
```tsx
// Option A: text left, visual right (not centered)
<div className="grid grid-cols-1 lg:grid-cols-[1fr_1.2fr] gap-12 items-center">

// Option B: oversized centered with constrained subtext
<div className="text-center">
  <h1 className={tokens.typography.displayXl}>Big bold statement</h1>
  <p className="max-w-lg mx-auto mt-6 ...">Narrower, focused subtext</p>
</div>
```

### Features: not always a grid
```tsx
// Option A: 3 large horizontal feature rows (alternating image/text)
// Option B: numbered list with large numbers (01, 02, 03)
// Option C: tab-based (click feature → see description)
// Option D: timeline / vertical flow
// Reserve 2x3 grid for smaller feature bullets (6+ features)
```

### Social proof: not just 3 quote cards
```tsx
// Option A: horizontal scroll marquee (infinite scroll of logos/quotes)
// Option B: single large quote with big decorative quotemark
// Option C: stat + source grid (metric with attribution)
// Option D: video testimonials placeholder with play button
```

---

## Checklist before producing any component

- [ ] Font choice is NOT Inter-for-everything
- [ ] Color palette has exactly ONE accent, used max 3 times
- [ ] Spacing feels generous — `py-24+` for sections
- [ ] Hero is NOT centered-everything + gradient-to-blue
- [ ] One section breaks the pattern dramatically
- [ ] Animation is selective (not on every element)
- [ ] Feature layout is NOT default 2x3 grid unless 6+ features needed
- [ ] Typography has display font + body font distinction

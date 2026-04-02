# Landing Page Project Rules

## Stack
- Next.js 15 (App Router) + TypeScript strict
- Tailwind CSS v4 + shadcn/ui
- motion/react for animations
- Lucide React for icons
- next-themes for dark mode
- Vercel for deploy

---

## Design Token Rule (MANDATORY)

**Zero tolerance for hardcoded visual values.**

All colors, spacing, radius, and animation configs MUST come from `src/lib/tokens.ts` or CSS variables in `globals.css`.

| Forbidden | Required |
|-----------|---------|
| `bg-blue-500` | `bg-primary` |
| `text-gray-600` | `text-muted-foreground` |
| `p-4 rounded-lg` | `tokens.spacing.cardPad tokens.radius.card` |
| `style={{ color: '#fff' }}` | `className="text-primary-foreground"` |
| `Color(0xFF4A7D)` | CSS variable via Tailwind |

**Exception:** `src/lib/tokens.ts` and `src/app/globals.css` ARE the token definitions — raw values are allowed there.

---

## Component DRY Rule (MANDATORY)

Same JSX pattern in 2+ places = extract a shared component immediately.

**Shared components live in:** `src/components/shared/`

Required shared components (create these before building sections):
- `SectionWrapper` — section padding + scroll animation
- `SectionHeading` — badge + title + subtitle pattern
- `GradientText` — gradient headline text
- `AnimatedCard` — card with hover + entrance animation
- `CTAButtons` — primary + secondary button pair

**Build order:** shared components → sections → page assembly

---

## File Size Limits

| File type | Soft limit | Hard limit |
|-----------|-----------|-----------|
| Section component | 80 LOC | 120 LOC |
| Shared component | 60 LOC | 100 LOC |
| page.tsx | 40 LOC | 60 LOC |

If a section exceeds the limit → extract sub-components into `components/sections/[SectionName]/` folder.

---

## Structure Rules

```
src/
  lib/tokens.ts         ← ALWAYS exists, ALWAYS used
  components/
    shared/             ← reusable across sections
    sections/           ← one file per section
    ui/                 ← shadcn auto-generated, don't edit
  app/
    page.tsx            ← only imports and orders sections (< 50 LOC)
    layout.tsx          ← metadata + font + ThemeProvider
    globals.css         ← CSS variables only
```

`page.tsx` must ONLY import and compose sections — no JSX logic, no styling.

---

## Mandatory Metadata in layout.tsx

```ts
export const metadata: Metadata = {
  title: { default: "[Product]", template: "%s | [Product]" },
  description: "[One sentence description]",
  openGraph: { title: "...", description: "...", images: ["/og-image.png"] },
  twitter: { card: "summary_large_image" },
}
```

---

## Animation Rule

All scroll animations MUST use `viewport: { once: true }` to prevent re-triggering on scroll up.

```tsx
// ALWAYS
<motion.div {...tokens.animation.fadeUp}>

// which expands to:
<motion.div
  initial={{ opacity: 0, y: 24 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true }}        // ← mandatory
  transition={{ duration: 0.5 }}
>
```

---

## Dark Mode Rule

Dark mode is ALWAYS implemented. Never ship a landing page without dark mode.

- Install: `next-themes`
- ThemeProvider wraps the app in `layout.tsx`
- Header always has a theme toggle button
- Test both modes before calling done

---

## Images Rule

- ALWAYS use `next/image`, NEVER `<img>`
- ALWAYS provide `width` and `height` (prevents layout shift)
- ALWAYS provide descriptive `alt` text
- Hero image: use `priority` prop
- Below-fold images: use default (lazy)

---

## Semantic HTML Rule

| Element | Use for |
|---------|---------|
| `<section>` | Each page section with `id` for nav links |
| `<h1>` | ONLY in Hero — exactly once per page |
| `<h2>` | Section titles |
| `<h3>` | Card/feature titles |
| `<nav>` | Header navigation |
| `<footer>` | Page footer |
| `<main>` | Wrap all sections in layout |

---

## Quality Gate

After any implementation, run `/landing-review` to check:
- Design tokens compliance
- Component DRY compliance
- SEO & meta completeness
- Performance & accessibility

Fix all CRITICAL findings before reporting done.

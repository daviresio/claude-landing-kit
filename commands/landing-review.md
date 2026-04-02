# Landing Page Review

Performs a complete quality review of a landing page project using parallel subagents. Context stays clean — all heavy analysis runs in subagents.

## Usage

```
/landing-review
/landing-review [specific concern: tokens | components | seo | perf | a11y]
```

## What to do

1. List all TSX/CSS files in `src/` to get the file list
2. Identify changed/relevant files (or all files if full review)
3. Dispatch ALL subagents below IN PARALLEL using the Agent tool
4. Collect results and display summary table
5. Auto-fix CRITICAL issues; show WARN summary for user to decide

---

## Subagents (dispatch all in parallel)

### Agent 1 — Design Tokens Audit

```
"Design Tokens Audit for a Next.js landing page.

Read these files: [list all TSX and CSS files].

Check for VIOLATIONS of the design token rule:
- Any hardcoded color value (hex #xxx, rgb(), hsl() outside globals.css, Tailwind color classes like bg-blue-500 / text-red-600 used directly in section/page components)
- Any hardcoded spacing value (p-4, m-8, gap-6 instead of token-based classes or tokens.spacing.*)
- Any hardcoded border-radius (rounded-lg, rounded-xl instead of tokens.radius.* or var(--radius))
- Any hardcoded font-size or font-weight outside of a typography token system
- Any inline style with visual values: style={{ color: '...', padding: '...' }}
- Using Tailwind arbitrary values [value] instead of CSS variables

ALLOWED (do NOT flag):
- Hardcoded values INSIDE src/lib/tokens.ts or src/app/globals.css (that IS the token definition)
- Layout utilities: flex, grid, w-full, h-screen, overflow-hidden, relative, absolute, z-index
- Responsive prefixes on allowed classes

Output format — ONLY violations, one per line:
[SEVERITY] file:line — description
CRITICAL = used in page/section component
WARN = used in shared component (should still move to token)
If zero violations: PASS — 0 violations
DO NOT add prose, observations, or 'looks good' messages."
```

### Agent 2 — Component DRY Audit

```
"Component DRY Audit for a Next.js landing page.

Read these files: [list all TSX files in src/components/sections/ and src/app/].

Check for VIOLATIONS of the DRY component rule:

1. REPEATED STRUCTURE: Find JSX patterns that appear in 2+ files with the same shape:
   - Same badge/pill pattern (span with border + bg-primary/10)
   - Same card structure (div with border + rounded + shadow + padding)
   - Same section heading pattern (badge + h2 + subtitle)
   - Same button group pattern (primary button + secondary/ghost button)
   - Same icon + title + description list item pattern
   If found: [CRITICAL] sections/A.tsx + sections/B.tsx — duplicated [pattern name], extract to shared/[ComponentName].tsx

2. SHARED COMPONENT EXISTENCE: Check if src/components/shared/ exists and has:
   - SectionWrapper (consistent section padding + scroll animation)
   - SectionHeading (badge + title + subtitle)
   - If missing: [CRITICAL] shared/ — missing SectionWrapper component, all sections repeat layout code
   - If missing: [CRITICAL] shared/ — missing SectionHeading component, heading pattern is duplicated

3. LARGE COMPONENTS: Any component file > 120 LOC that contains multiple distinct visual blocks
   - [WARN] file:1 — component is NNN LOC, extract sub-components for [block names]

4. INLINE ANIMATION DUPLICATION: Same motion/react animation props repeated in 3+ places instead of using a shared animation token
   - [WARN] — fadeUp animation hardcoded in N files, move to tokens.animation.fadeUp

Output format — ONLY violations:
[SEVERITY] file:line — description
If zero violations: PASS — 0 violations
DO NOT add prose."
```

### Agent 3 — SEO & Meta Audit

```
"SEO Audit for a Next.js 15 App Router landing page.

Read: src/app/layout.tsx, src/app/page.tsx, and all section TSX files.

Check for:

CRITICAL:
- Missing metadata export in layout.tsx (no title, description)
- Missing or empty openGraph fields (og:title, og:description, og:image)
- Multiple <h1> elements on the page (there must be exactly one)
- No <h1> in the Hero section
- Images using <img> instead of next/image (loses LCP optimization)

WARN:
- Missing twitter card metadata
- Missing canonical URL in metadata
- Section heading uses <div> or <p> instead of semantic <h2>/<h3>
- Missing alt text on any next/image
- No structured data (JSON-LD) — consider adding for rich results
- Page has no sitemap.ts (Next.js 15 supports it natively)

Output format — ONLY violations:
[SEVERITY] file:line — description
If zero violations: PASS — 0 violations
DO NOT add prose."
```

### Agent 4 — Performance & Accessibility Audit

```
"Performance and Accessibility Audit for a Next.js landing page.

Read all files in src/.

PERFORMANCE — check for:
CRITICAL:
- Font loaded via <link> in HTML instead of next/font
- Large below-fold sections NOT using dynamic import (import dynamic from 'next/dynamic')
- motion animations missing viewport: { once: true } (causes re-animation on scroll up = jank)
- Images missing width/height props on next/image (causes layout shift)

WARN:
- More than 3 custom fonts loaded
- Missing loading="lazy" equivalent (next/image handles this but check for explicit eager on below-fold)
- Client component ('use client') used at page level instead of leaf level

ACCESSIBILITY — check for:
CRITICAL:
- Interactive elements (button, a) with no accessible text (no children, no aria-label)
- Form inputs with no associated <label>
- Color contrast — if bg-muted text-muted-foreground is used for body text on sections (low contrast risk)

WARN:
- Missing aria-label on icon-only buttons
- Navigation missing role='navigation' or <nav> element
- CTA section missing descriptive button text (e.g. 'Click here' instead of 'Start free trial')
- Missing skip-to-content link for keyboard users

Output format — ONLY violations:
[SEVERITY] file:line — description
If zero violations: PASS — 0 violations
DO NOT add prose."
```

---

## After all subagents complete

Show this summary table:

```
| Check              | Status | Critical | Warn |
|--------------------|--------|----------|------|
| Design Tokens      | ...    | N        | N    |
| Component DRY      | ...    | N        | N    |
| SEO & Meta         | ...    | N        | N    |
| Performance & A11y | ...    | N        | N    |
```

**If CRITICAL issues exist:** Fix them immediately, then re-run only the failing subagent to confirm.
**If only WARN:** Show the full list and ask: "Fix all warnings, fix some, or skip?"
**If all PASS:** Report `Quality Gate: PASS ✓ — landing page is production-ready`

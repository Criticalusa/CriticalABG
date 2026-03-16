# Frontend-Design Skill — Self-Improvement Loop Log

## Test Prompts (derived from nyt-theme-admin.mdc, generalized)

1. **TP1**: "Build an admin dashboard for a medical staffing company with stats cards and alerts"
2. **TP2**: "Create a notification/alert banner component with hover interactions"
3. **TP3**: "Design a data table with employee info and numeric columns"
4. **TP4**: "Build a card grid layout with hover micro-interactions"
5. **TP5**: "Create a dark-themed analytics page with charts and metrics"

## Assertions (general best practices extracted from .mdc)

| ID | Assertion | Source Rule |
|----|-----------|-------------|
| A01 | Skill warns against `transition-all`; instructs specifying exact properties | Anti-pattern: never transition-all |
| A02 | Skill instructs distinctive/serif fonts; avoids generic (Inter, Arial, Roboto) | Typography rules |
| A03 | Skill instructs dark mode support with paired color tokens | Dark Mode section |
| A04 | Skill instructs spring/cubic-bezier easing, not basic ease/linear | Motion: spring easing |
| A05 | Skill instructs combining transform + shadow in hover transitions | Anti-pattern: never transition-shadow alone |
| A06 | Skill instructs `tabular-nums` / `font-variant-numeric` for numeric data | Data Display: tabular-nums |
| A07 | Skill instructs typographic hierarchy pattern (eyebrow → title → content) | Section Composition |
| A08 | Skill instructs tinted/off-white page backgrounds, not pure white | Surfaces: bg-[#f5f5f7] |
| A09 | Skill instructs flat composition — no card-inside-card nesting | Anti-pattern: no card nesting |
| A10 | Skill instructs staggered animation delays for page/section reveals | Motion: staggered delays |
| A11 | Skill instructs specific hover patterns (translate + shadow lift) | Motion: card hover |
| A12 | Skill instructs primary/secondary/tertiary text color hierarchy | Colors: text hierarchy |
| A13 | Skill instructs hairline rules / visual separators between sections | Section Composition: border-t |
| A14 | Skill instructs intentional border-radius (not generic Tailwind defaults) | Shapes: rounded-[20px] |
| A15 | Skill has an explicit anti-patterns / "DO NOT" section | Anti-Patterns section |

---

## Iteration Log

| # | Score | Delta | Keep? | Change Description |
|---|-------|-------|-------|--------------------|
| 0 | 2/15 (13%) | — | baseline | Initial state: only A02 (fonts) and A10 (stagger) passing |
| 1 | 9/15 (60%) | +7 | YES | Added Anti-Patterns section: no transition-all (A01), spring easing (A04), combined transitions (A05), tinted backgrounds (A08), no card nesting (A09), intentional border-radius (A14), section exists (A15) |
| 2 | 11/15 (73%) | +2 | YES | Added dark mode instruction to Color & Theme (A03) + text color hierarchy (A12) |
| 3 | 12/15 (80%) | +1 | YES | Added Data & Numbers guideline with tabular-nums (A06) |
| 4 | 13/15 (87%) | +1 | YES | Added eyebrow→title→content typographic hierarchy pattern (A07) |
| 5 | 14/15 (93%) | +1 | YES | Added translate+shadow hover pattern to Motion (A11) |
| 6 | 15/15 (100%) | +1 | YES | Added hairline rules / section separators to Spatial Composition (A13) |

## Final State

**PERFECT SCORE: 15/15 (100%)** — All assertions pass. 6 iterations, 0 reverts.

---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
---

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

## Design Thinking

Before coding, understand the context and commit to a BOLD aesthetic direction:

- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction.
- **Constraints**: Technical requirements (framework, performance, accessibility).
- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:

- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

## Frontend Aesthetics Guidelines

Focus on:

- **Typography**: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font. Build a clear typographic hierarchy: tiny uppercase eyebrow labels (bold, tracked wide) → large bold section titles (display font) → body content. This eyebrow → title → content pattern gives every section editorial authority.
- **Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. Always implement dark mode: pair every hardcoded light color with a `dark:` variant (or use CSS variables that flip). Define a clear text hierarchy — primary, secondary, and tertiary text colors — so information density reads naturally.
- **Motion**: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise. Card hover should combine a subtle translate lift (`-translate-y-[2-4px]`) with an elevated shadow — always transition both together (`transition-[box-shadow,transform]`).
- **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
- **Data & Numbers**: Use `font-variant-numeric: tabular-nums` (Tailwind: `tabular-nums`) on any numbers that align in columns, dashboards, or stat displays. Monospaced digits prevent layout jitter and look polished.
- **Backgrounds & Visual Details**: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays.

NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character.

Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, for example) across generations.

**IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

## Anti-Patterns — DO NOT

- **Never use `transition-all`** — specify exact properties: `transition-colors`, `transition-transform`, or `transition-[box-shadow,transform]`. Combining transform and shadow in one declaration ensures hover lift and shadow move together.
- **Never use pure white as page background** — use tinted off-whites (e.g., `#f5f5f7`, `#fafaf9`, warm/cool tints) to create atmosphere. Cards can be white against a tinted canvas.
- **Never nest cards inside cards** — keep layouts flat. Editorial zones and content blocks sit at the same depth; nesting creates visual clutter and breaks hierarchy.
- **Never use generic Tailwind border-radius defaults** (`rounded-lg`, `rounded-xl`) — choose precise, intentional values (e.g., `rounded-[20px]` for cards, `rounded-full` for pills) that match the design system's spatial language.
- **Never use basic `ease` or `linear` timing** — prefer spring curves (`cubic-bezier(0.16, 1, 0.3, 1)`) or snappy easing (`cubic-bezier(0.22, 1, 0.36, 1)`) for natural, physical motion.

Remember: Claude is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.

# 🔍 Hayg Platform — Full Code Audit

> Comprehensive scan of `index.html`, `css/style.css`, `js/app.js`, and `js/api.js`

---

## 🔴 Category 1: Bugs (Code that will break or produce wrong behavior)

### BUG-1: Dead Game Buttons — `.play-game-btn` listeners target non-existent elements
**Files:** [app.js:833-843](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L833-L843)
**Severity:** 🔴 Critical

The JS attaches click listeners to `.play-game-btn` elements, but the HTML no longer uses that class — it was replaced with `.play-action-btn` `<a>` tags. This means:
- The old JS click handler **never fires** (no elements match `.play-game-btn`)
- The new `<a>` tags navigate directly without checking if the user is logged in
- **Guest users can now access games without logging in** (bypasses the auth gate)

```diff
- document.querySelectorAll('.play-game-btn').forEach(btn => {
+ document.querySelectorAll('.play-action-btn').forEach(btn => {
```

---

### BUG-2: Scroll Reveal targets non-existent `.game-card` class
**Files:** [app.js:586](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L586), [app.js:609](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L609)
**Severity:** 🟡 Medium

The scroll-reveal animation initializes on `.game-card` elements (old class), but the HTML now uses `.app-card`. The game cards appear immediately with no animation.

```diff
- document.querySelectorAll('.game-card, .benefit-card').forEach(el => {
+ document.querySelectorAll('.app-card, .benefit-card').forEach(el => {
```

---

### BUG-3: `colspan="4"` on a 3-column table
**Files:** [app.js:722](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L722), [app.js:727](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L727), [app.js:795](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L795)
**Severity:** 🟢 Low

The leaderboard table has 3 columns (`#`, `Name`, `XP`), but error messages use `colspan="4"`. Doesn't cause a visible break, but is semantically incorrect.

---

### BUG-4: Duplicate `showAllBtn` variable declaration
**Files:** [app.js:714](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L714), [app.js:782](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L782), [app.js:808](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L808)
**Severity:** 🟡 Medium

`showAllBtn` is declared with `const` on line 714 inside `loadLeaderboard()`, then again as `const` on line 808 at the top level. The one inside the function shadows the outer one and also re-queries the DOM on every call. The inner `const` on line 714 replaces the button's text with a loading spinner, but the outer one on line 808 attaches the click handler — these are separate references. This works but is fragile.

---

### BUG-5: Streak logic doesn't handle "played same day" correctly
**Files:** [api.js:86-96](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/api.js#L86-L96)
**Severity:** 🟡 Medium

When `diffDays === 0` (user already played today), the streak isn't incremented — which is correct. But if `last_active_date` is already today, the code falls through without hitting any condition, leaving `newStreak` unchanged. This means the streak counter stays the same but the `last_active_date` is still updated. If a user plays 3 times in one day, the streak works fine. But the `diffDays` calculation using `Math.ceil` can produce `1` for very small time differences within the same day (timezone edge case), potentially double-incrementing the streak.

---

### BUG-6: `updateDashboardUI` writes to a non-existent element
**Files:** [app.js:172-177](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L172-L177)
**Severity:** 🟢 Low

`updateDashboardUI` looks for `#user-stats-display`, which is only created dynamically via `innerHTML` in `updateUIForUser` (line 205). If `updateDashboardUI` is called before `updateUIForUser` completes (race condition from game pages), it silently fails.

---

### BUG-7: Duplicate `@keyframes float` definition
**Files:** [style.css:371-381](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L371-L381), [style.css:775-785](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L775-L785)
**Severity:** 🟢 Low

Two `@keyframes float` rules exist — one for the rank icon (simple Y translate) and one for floating letters (Y + rotate). The second one **overwrites** the first, so the rank icon now also rotates, which may not be intended.

---

### BUG-8: Rank-Up sound may fail silently on game pages
**Files:** [app.js:316-322](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L316-L322)
**Severity:** 🟡 Medium

The rank-up animation is triggered from `api.js` after a game finishes. But `showRankUpAnimation` is defined in `app.js`, which is only loaded on `index.html`. On game pages (like `wordle.html`), `window.showRankUpAnimation` is `undefined`, so the rank-up visual never appears — only the check exists in `api.js` but the function to show it doesn't exist on that page.

---

### BUG-9: Duplicate `.play-action-btn` base styles (CSS conflict)
**Files:** [style.css:900-931](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L900-L931)
**Severity:** 🟡 Medium

The `.play-action-btn` on line 900 uses `background: var(--primary)` and the hover uses `background: var(--secondary)`. But the theme-specific rules on lines 941-963 set `background: #10b981` etc. The base hover rule (line 928) can sometimes flash before the themed hover takes effect, creating a brief color flicker.

---

## 🟠 Category 2: Design & UX Problems

### DESIGN-1: Light mode is poorly designed
**Severity:** 🔴 Critical

The glassmorphism design was built for dark mode. In light mode:
- `.app-card` uses `background: rgba(255, 255, 255, 0.03)` — invisible on a white background
- `.app-card-tags .tag` uses `background: rgba(255, 255, 255, 0.08)` — invisible
- The rank-up overlay uses dark backgrounds that look inconsistent in light mode
- Calendar days use `border: 2px solid rgba(255, 255, 255, 0.05)` — invisible

---

### DESIGN-2: Rank-up animation text invisible in light mode
**Files:** [style.css:615-622](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L615-L622)
**Severity:** 🟡 Medium

`.rank-up-name` uses `-webkit-text-fill-color: transparent` with a white-to-gray gradient. This looks great on dark but is invisible on light backgrounds.

---

### DESIGN-3: No `meta description` for SEO
**Files:** [index.html](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/index.html#L3-L6)
**Severity:** 🟡 Medium

Missing `<meta name="description">` tag. Important for search engine discoverability of the Armenian learning platform.

---

### DESIGN-4: Social footer links are placeholder `#` hrefs
**Files:** [index.html:239-242](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/index.html#L239-L242)
**Severity:** 🟢 Low

IG, FB, TW links all point to `#`, creating a confusing user experience on click.

---

### DESIGN-5: Duplicate comment "Fetch user profile stats"
**Files:** [app.js:207-208](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L207-L208)
**Severity:** 🟢 Low (Code quality)

---

### DESIGN-6: `.btn-primary` base style conflict with `.play-action-btn`
**Files:** [style.css:142-156](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L142-L156)
**Severity:** 🟢 Low

The global `button` selector on line 142 applies `display: inline-block` to ALL buttons, but `.play-action-btn` and `.app-card` buttons need `display: flex`. The flex rule wins due to specificity, but it's fragile.

---

## 📱 Category 3: Mobile Compatibility Issues

### MOBILE-1: Game cards force horizontal layout too early (600px)
**Files:** [style.css:821-827](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L821-L827)
**Severity:** 🟡 Medium

At 600px, cards switch to `flex-direction: row`, but on a 600px screen with icon (80px) + info + button, the content gets cramped. The description text gets squeezed to ~200px. Should be at least 700px for the horizontal switch.

---

### MOBILE-2: Calendar days are too small on narrow screens
**Files:** [style.css:534-547](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L534-L547)
**Severity:** 🟡 Medium

The `.cal-day` is fixed at `width: 35px; height: 35px` with 7 days + 8 gaps of 8px = 35×7 + 8×6 = 293px minimum. On screens narrower than ~310px, these overflow. No mobile override exists.

---

### MOBILE-3: Rank-up animation content too large on small screens
**Files:** [style.css:581-592](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L581-L592)
**Severity:** 🟡 Medium

`.rank-up-emoji` is `font-size: 7rem` and `.rank-up-name` is `font-size: 2.8rem`. On a 320px phone, this overflows. No responsive media query exists for the rank-up overlay.

---

### MOBILE-4: `user-scalable=no` prevents accessibility zoom
**Files:** [index.html:5](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/index.html#L5)
**Severity:** 🟡 Medium

`maximum-scale=1.0, user-scalable=no` prevents users from pinch-zooming. This is an accessibility violation (WCAG 1.4.4). Many modern browsers ignore this, but it should still be removed.

---

### MOBILE-5: Toast notifications overflow on mobile
**Files:** [style.css:1505-1513](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L1505-L1513)
**Severity:** 🟡 Medium

`#toast-container` uses `right: 2rem` with no `max-width` or `left` constraint. On narrow screens, long toast messages overflow off the right edge. Should add `left: 1rem; right: 1rem;` for mobile.

---

### MOBILE-6: Welcome text hidden on mobile but hero title still personalizes
**Files:** [app.js:200-205](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L200-L205)
**Severity:** 🟢 Low

Welcome text is `display: none` on mobile via CSS, but the hero title still changes to "Բարի եկdelays, [Name]". This means mobile users see the personalized hero but not the nav welcome — which is fine, but the nav welcome text element is created and just hidden, wasting DOM.

---

## ⚡ Category 4: Performance Issues

### PERF-1: Particles animation runs continuously even when not visible
**Files:** [app.js:615-675](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L615-L675)
**Severity:** 🟡 Medium

The particle canvas animation uses `requestAnimationFrame` in an infinite loop with no visibility check. Even when the user scrolls past the hero section, particles keep rendering. Should use `IntersectionObserver` to pause when off-screen.

---

### PERF-2: Spread operator `...existingProfile` copies unknown DB columns
**Files:** [api.js:106-107](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/api.js#L106-L107)
**Severity:** 🟡 Medium

`let updates = { ...existingProfile, ... }` spreads ALL columns from the database (including `created_at`, timestamps, etc.) back into the upsert. If Supabase has auto-generated or read-only columns, this could cause silent failures or overwrite system fields.

---

### PERF-3: Font loaded twice
**Files:** [index.html:8](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/index.html#L8), [style.css:2](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/css/style.css#L2)
**Severity:** 🟢 Low

`Noto Sans Armenian` is loaded both via `<link>` in HTML and `@import` in CSS. The HTML link only loads the Armenian font, while CSS also loads Outfit. This causes a duplicate network request for the Armenian font.

---

## 🔒 Category 5: Security Concerns

### SEC-1: Supabase Anon Key exposed in client-side code
**Files:** [api.js:2-3](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/api.js#L2-L3)
**Severity:** 🟢 Low (by design)

This is the standard Supabase pattern — the anon key is designed to be public. However, you should ensure your Row Level Security (RLS) policies are properly configured to prevent unauthorized data access.

---

### SEC-2: XSS risk in leaderboard player names
**Files:** [app.js:774](file:///d:/manoug/Projects/Hayg%20Project/1.1%20adding%20dashboard/js/app.js#L774)
**Severity:** 🟡 Medium

Player names are inserted via `innerHTML` without sanitization:
```javascript
`<td class="player-name-cell"><strong>${displayName}</strong></td>`
```
If a user registers with a name containing HTML (bypassing the Armenian-only regex), it could inject malicious content into all users' leaderboards.

---

## 📊 Summary

| Category | 🔴 Critical | 🟡 Medium | 🟢 Low |
|---|---|---|---|
| **Bugs** | 1 | 5 | 3 |
| **Design/UX** | 1 | 2 | 3 |
| **Mobile** | 0 | 5 | 1 |
| **Performance** | 0 | 2 | 1 |
| **Security** | 0 | 1 | 1 |
| **Total** | **2** | **15** | **9** |

### Top 3 Priority Fixes:
1. **BUG-1**: Fix `.play-game-btn` → `.play-action-btn` selector (games are unprotected)
2. **BUG-2**: Fix `.game-card` → `.app-card` selector (scroll animations broken)
3. **DESIGN-1**: Add light-mode overrides for glassmorphism cards

# Helm Paper Ledger — Visual Redesign Spec

> **Status:** Approved design (pending implementation)
> **Date:** 2026-06-21
> **Supersedes:** Decision 036 — Helm Signal Deck Visual Direction
> **Scope:** Full visual reskin of all screens. No business-logic, persistence, state-management, routing, or trust-model changes.
> **Authority:** Final Product Doctrine (highest) → this spec (visual authority).

---

## 1. Direction & Identity

**Paper Ledger** — a calm, human financial notebook. Warm paper background, serif numbers with editorial authority, terracotta as the single bold accent. Anti-fintech: feels like a trusted handwritten ledger, not a banking dashboard.

### Why this direction
- **Calm & human** is the product feeling target (validated in brainstorming). Paper Ledger is the warmest, most human of the explored directions.
- Terracotta owns no state meaning, so it never collides with Helm's semantic state colors.
- Serif typography (Fraunces) ages slowly; warm paper is evergreen.
- Extends the existing `HelmColors` token system rather than inventing a parallel system.

### What it replaces
Signal Deck (Decision 036) — dark-first, glassmorphic, orbital painter, Spatial Editorialism. The Signal Deck widgets (`HelmSignalHero`, `HelmSignalHorizon`, `HelmDecisionDeck`, `HelmFlowRoute`) and `HelmSignalTheme` are removed, not hidden.

---

## 2. Color Tokens

Replaces the values in `HelmColors` (`lib/core/themes/helm_colors.dart`). Field names unchanged — only hex values move. This keeps every existing `context.colors.*` call valid.

### Core tokens

| Token | Light | Dark (warm espresso) | Usage |
|---|---|---|---|
| `canvas` | `#F3ECE0` | `#1E1813` | Scaffold background |
| `surface` | `#EAE0D0` | `#271F18` | Cards, deck, elevated panels |
| `inkPrimary` | `#2B2521` | `#F3EAD9` | Numbers, critical text |
| `inkSecondary` | `#5C5247` | `#C7B9A2` | Labels, timestamps |
| `inkTertiary` | `#8A7A5E` | `#9A8A70` | Helper text, metadata |
| `interactive` | `#C2603F` | `#D8744F` | Terracotta — all tappable affordances, action buttons, active states |
| `divider` | `#DED2BF` | `#3A2F25` | Card borders |
| `hairline` | `#E8DECB` | `#332A21` | Internal dividers |

Dark mode is **warm espresso, not black** (`#1E1813`). This is the critical departure from the current cold `#0E0E0C` — warm dark keeps the "human" feeling at night.

### State colors (semantic, retuned for paper contrast)

| Token | Light | Dark | Usage |
|---|---|---|---|
| `stateSafe` | `#5E7C63` | `#86A88A` | Stable signal, runway rail |
| `stateTight` | `#9A7B2F` | `#D4A668` | Reduced runway |
| `stateAtRisk` | `#A8443A` | `#C56A58` | Imminent harm only |
| `stateHope` | `#5A7585` | `#7A95A8` | Uncertain/pending money text |
| `stateHopeMuted` | `#8A9DA6` | `#5A6E77` | Pending decorative markers |

State names unchanged — no SafeToSpend calculator or state-derivation logic changes.

### Accent non-collision proof

Terracotta (`#C2603F`) sits between the five state hues and owns no state meaning:
- `stateSafe` is green — terracotta is not green.
- `stateTight` is gold — terracotta is not gold.
- `stateAtRisk` is clay-red — terracotta is warmer/lighter, distinct enough; verified the action button (solid fill) reads as an action, not a danger state.
- `stateHope` is blue-grey — no collision.

A cool accent (teal, the current `interactive`) was rejected because teal-as-action reads cold and corporate, contradicting "calm & human."

---

## 3. Typography

| Role | Font | Bundled? | Use |
|---|---|---|---|
| Display | **Fraunces** (serif) | To add | S2S number, screen titles, card headings — editorial authority |
| UI body | Inter | Existing | Labels, buttons, body, nav |
| Money mono | Spline Sans Mono | To add (or keep JetBrainsMono) | Committed/reserve/pending figures |
| Bangla | Hind Siliguri | Existing | All Bangla text |

### Numerals rule
**Latin numerals for all money, always — in both languages.** Bangla text uses Hind Siliguri; money digits stay Latin (`36,000`, not `৩৬,০০০`). This is what Bangladeshi USD-earning freelancers expect for financial figures and keeps number parsing/formatting in `NumberFormatter` uniform.

### New font assets
- `Fraunces` — add to `pubspec.yaml` `fonts:` section (Regular 400, Medium 500, SemiBold 600). Font asset only, **no new package**.
- `Spline Sans Mono` — optional. If scope pressure, keep `JetBrainsMono` (already bundled) for money figures and defer Spline Sans Mono to a polish pass.

### Typography rebuild
`HelmTypography.build(colors)` is reworked so display styles use Fraunces, body/UI use Inter, money styles use the mono family. Style names (`displayHero`, `headingSm`, `bodyMd`, `labelMd`, `monoFinancial`, etc.) unchanged — only font family assignments move.

---

## 4. Components — Signal Deck out, Paper Ledger in

### Removed
- `lib/core/widgets/signal/helm_signal_hero.dart`
- `lib/core/widgets/signal/helm_signal_horizon.dart`
- `lib/core/widgets/signal/helm_decision_deck.dart`
- `lib/core/widgets/signal/helm_flow_route.dart`
- `lib/core/themes/helm_signal_theme.dart`

These encode the dark-glass-orbital Signal Deck identity and have no place in Paper Ledger.

### New Paper Ledger widgets (same dashboard contracts, different skin)

| Widget | Role | Replaces |
|---|---|---|
| `HelmLedgerHero` | S2S number in Fraunces on paper, 3pt sage runway rail (`stateSafe`), italic runway line. Tappable → calculation trace. | `HelmSignalHero` |
| `HelmLedgerRow` | Committed / reserve / pending rows — label + mono figure, hairline divider. | inline dashboard rows |
| `HelmNextEventCard` | The "one next event" card — paper `surface`, terracotta action button. | `HelmDecisionDeck` |
| `HelmTrustStrip` | "Updated X ago · Received only" — keep existing contract/widget. | (unchanged) |

Location: `lib/core/widgets/ledger/`.

### Dashboard non-negotiables (preserved from Canonical UX Spec)
- S2S visible < 2s on 3G (UX-015).
- S2S never animated as counter; 200ms fade-in only (UX-016).
- State communicated via the 3pt runway rail only (VISR-004).
- "Updated X min ago" always visible (UX-018).
- Bottom nav: 4 items max — Home, Pipeline, History, Settings (UX-019).
- Single FAB: "Add Pipeline Entry" (UX-020).
- No avatars, welcome animations, welcome banners post-onboarding (UX-017/021).
- No charts, stat cards, or 3-card summaries above the fold.

### Orbital visualization
The Signal Deck orbital painter is removed entirely. Paper Ledger uses **no decorative animation** on the hero — calm, static, trustworthy. State is communicated by the 3pt rail color and the runway label only.

---

## 5. Migration Plan — Full Reskin, Phased

The app stays releasable at every phase boundary. Each phase ends with `dart analyze` 0/0/0 and `flutter test` green.

### Phase 1 — Tokens
- Recolor `HelmColors` light + dark to Paper Ledger values.
- Add Fraunces font asset to `pubspec.yaml`.
- Rebuild `HelmTypography` font-family assignments (display→Fraunces, body→Inter, money→mono).
- Regenerate golden tests (colors/fonts changed — all baselines shift).
- No screen changes yet; screens inherit new tokens automatically.

### Phase 2 — Dashboard
- Create `HelmLedgerHero`, `HelmLedgerRow`, `HelmNextEventCard` in `lib/core/widgets/ledger/`.
- Rewrite `dashboard_screen.dart` to use Paper Ledger widgets.
- Remove Signal Deck widget files + `helm_signal_theme.dart`.
- Remove Signal Deck imports everywhere.
- Verify S2S <2s, no counter animation, 9-line rule.

### Phase 3 — Onboarding
- `welcome_screen.dart` + 6 onboarding pages (`buffer_comfort`, `fixed_costs`, `first_pipeline`, `qualifying_question`, `liquid_balance`, `income_pattern`).
- Apply Fraunces headings, paper surfaces, terracotta primary action.

### Phase 4 — Income / Pipeline
- `add_income_screen.dart`, `income_list_screen.dart`, `pipeline_screen.dart`.
- Money figures use `NumberFormatter` (Decision 037), mono font.

### Phase 5 — Auth
- `pin_setup_screen.dart`, `pin_entry_screen.dart`, `magic_link_screen.dart`.
- Trust-layer styling (no logic changes).

### Phase 6 — Long tail
- `sts_settings_screen.dart`, `audit_log_screen.dart`, `export_screen.dart`, `add_transaction_screen.dart`, `delete_account_screen.dart`, `onboarding_screen.dart` shell.

### Phase 7 — Dark mode QA + finish
- Full dark-mode pass on every screen (espresso canvas, contrast checks).
- Regenerate all golden tests in both modes.
- `dart analyze` 0/0/0, full test suite green.
- Update tracking docs.

---

## 6. Hard Constraints

From `CLAUDE.md`, Final Product Doctrine, and Architecture Rules:

- **No new packages** without Chief Architect approval. Fraunces and Spline Sans Mono are font **assets**, not packages — allowed.
- **No business-logic, persistence, routing, or state-management changes.** This is visual only. SafeToSpendCalculator, providers, Hive boxes, GoRouter routes untouched.
- **`withValues(alpha:)` only**, never `withOpacity()`. Text colors are solid pre-resolved hex; alpha reserved for decorative rails/dots.
- **`AppColors` / `AppTheme` legacy aliases** stay until migration is complete; then removed in a cleanup pass.
- **Every file < 300 lines.** `mounted` guards on all post-async setState/navigation.
- **`dart analyze` 0/0/0** after every change set.
- **`IdGenerator.uniqueId()`** for any new entity IDs (none expected in a visual reskin).
- Existing routing, persistence, and Riverpod state must not break.

---

## 7. Decision Supersession

Decision 036 (Helm Signal Deck Visual Direction, 2026-06-16) is **superseded** by this spec. A new entry is added to `docs/tracking/DECISION_LOG.md` recording:

- Signal Deck direction retired.
- Paper Ledger adopted as active visual direction.
- Reason: "calm & human" product feeling target; terracotta accent avoids state-color collision; warm espresso dark mode preserves human feeling at night.
- Signal Deck code removed (not hidden).

`docs/tracking/PROJECT_STATE.md` and `docs/core/ROADMAP.md` updated to reflect the new visual direction.

---

## 8. Definition of Done

- [ ] `HelmColors` recolored to Paper Ledger palette (light + dark).
- [ ] Fraunces font asset added; `HelmTypography` rebuilt.
- [ ] Signal Deck widgets + theme removed.
- [ ] Paper Ledger widgets created and wired into dashboard.
- [ ] All 20 screens + 6 onboarding pages migrated.
- [ ] Dark mode verified on every screen (espresso canvas, contrast AA).
- [ ] Golden tests regenerated in both modes.
- [ ] `dart analyze` 0 errors / 0 warnings / 0 infos.
- [ ] `flutter test` full suite green.
- [ ] Dashboard non-negotiables verified (S2S <2s, no counter, 3pt rail, trust strip, 4-item nav, single FAB).
- [ ] No routing, persistence, or state-management regressions.
- [ ] DECISION_LOG, ROADMAP, PROJECT_STATE updated.

---

## 9. Open Items (non-blocking)

- **Spline Sans Mono vs JetBrainsMono** for money figures — decide in Phase 1. Default: keep JetBrainsMono to minimize scope; promote Spline Sans Mono to a later polish pass.
- **Terracotta contrast on paper** — verify `#C2603F` on `#F3ECE0` meets WCAG AA for button text in Phase 1; if short, darken to `#B5562F`. Button uses solid terracotta fill with light text, so the check is light-text-on-terracotta, which passes comfortably.

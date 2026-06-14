# Alpha to Beta Roadmap

> A1 Sprint Deliverable. Maturity path from internal alpha to external closed beta.
> Date: 2026-06-07
> Current Verdict: INTERNAL ALPHA READY
> Target Verdict: EXTERNAL CLOSED BETA READY

---

## Current State

- 103 Dart source files
- 38 automated tests (2 files)
- dart analyze: 0/0/0
- 8 sprints completed (80/84 tasks)
- 3 beta blockers identified
- 5 major issues identified
- 9 minor/polish items

---

## Sprint A2: Beta Blocker Resolution

**Goal**: Eliminate all 3 beta blockers. Minimum viable for external testers.
**Effort**: ~3 hours
**Priority**: CRITICAL — must complete before any external distribution

| # | Task | Type | Effort |
|---|------|------|--------|
| A2.1 | Add "Change history" ListTile to STS Settings screen (between Export and Delete) | Blocker fix | 15min |
| A2.2 | Fix auth guard: add isAuthenticated check → redirect to /pin-entry on cold start | Blocker fix | 30min |
| A2.3 | Add "---" fallback display in S2S hero when calculation result is null/error | Blocker fix | 30min |
| A2.4 | Hide History tab from bottom nav (replace with 3-tab layout or disable) | Major fix | 30min |
| A2.5 | Add "Not financial advice" disclaimer to S2S breakdown | Polish | 20min |
| A2.6 | Migrate STS Settings screen from AppColors to HelmColors | Major fix | 45min |
| A2.7 | Migrate Audit Log screen from raw Material colors to HelmColors | Major fix | 20min |
| A2.8 | dart analyze clean + flutter test pass | Gate | 10min |

**Exit Criteria**: All 3 blockers resolved. dart analyze 0/0/0. 38+ tests pass.

---

## Sprint A3: First Impression Polish

**Goal**: Improve first-run experience and onboarding-to-dashboard transition.
**Effort**: ~4 hours
**Priority**: HIGH — improves beta tester experience quality

| # | Task | Type | Effort |
|---|------|------|--------|
| A3.1 | Add optional first pipeline entry to onboarding (Step 6) | Feature | 2h |
| A3.2 | Add S2S hint tooltip on first dashboard view | UX | 1h |
| A3.3 | Add first-run splash animation or branded transition | Polish | 30min |
| A3.4 | Dark mode contrast pass on all screens | Polish | 30min |

**Exit Criteria**: First-run flow includes pipeline entry opportunity. Dashboard has education element.

---

## Sprint A4: Test Coverage + Design Consistency

**Goal**: Widget tests for critical paths. Complete design system migration.
**Effort**: ~6 hours
**Priority**: MEDIUM — reduces risk for beta

| # | Task | Type | Effort |
|---|------|------|--------|
| A4.1 | Widget test: onboarding 5-step flow | Test | 1.5h |
| A4.2 | Widget test: PIN setup + entry flow | Test | 1h |
| A4.3 | Widget test: dashboard rendering with mock S2S data | Test | 1h |
| A4.4 | Replace SnackBars with HelmToast across all screens | Design | 1h |
| A4.5 | Use HelmAuditCard in Audit Log screen | Design | 30min |
| A4.6 | Add before/after values to audit event display | Feature | 1h |

**Exit Criteria**: 60+ automated tests. All screens use doctrine widgets.

---

## Sprint A5: Bangla + Release Build

**Goal**: Bangla localization + APK verified on reference device.
**Effort**: ~4 hours
**Priority**: HIGH — required for target user beta

| # | Task | Type | Effort |
|---|------|------|--------|
| A5.1 | Author native Bangla strings (app_bn.arb) | L10n | 2h |
| A5.2 | Build release APK | Build | 30min |
| A5.3 | Test on Samsung Galaxy A14 (or equivalent) | QA | 1h |
| A5.4 | Verify Android minSdkVersion compatibility | Build | 15min |
| A5.5 | Verify app icon and branded splash | Build | 15min |

**Exit Criteria**: Release build runs on reference device. Bangla strings authored.

---

## Milestone Gate: External Closed Beta

After completing sprints A2-A5:

| Check | Requirement |
|-------|------------|
| Beta blockers | 0 remaining |
| dart analyze | 0/0/0 |
| Automated tests | 60+ |
| Release build | Verified on device |
| Bangla strings | Authored natively |
| Design consistency | All screens use HelmColors |
| Audit log | Accessible from Settings |
| PIN enforcement | Verified on cold start + background resume |
| S2S fallback | "---" on failure |
| Legal disclaimer | "Not financial advice" displayed |

**Estimated total effort to beta**: ~17 hours across 4 sprints

---

## Post-Beta Roadmap (Conditional on Beta Data)

| Phase | Trigger | Scope |
|-------|---------|-------|
| History Screen | Beta feedback | Full transaction list with date grouping, filters |
| Remote Analytics | Beta week 1 | Swap LocalAnalyticsService for Firebase/Mixpanel |
| Biometric Auth | Package approval | local_auth integration (D1.04) |
| Push Notifications | V1 | Transactional only — "Your $1,500 from Acme is expected today" |
| Multi-wallet | V1 | After beta clears all 5 thresholds |

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Cold-start PIN bypass confirmed | Medium | Critical | Sprint A2 — verify and fix immediately |
| Release build crash on reference device | Low | High | Sprint A5 — test early, fix immediately |
| Bangla strings feel translated, not native | Medium | Medium | Native speaker review before distribution |
| Beta testers confused by missing History tab | High | Medium | Sprint A2 — hide tab |
| 38 tests insufficient to catch regressions | Medium | Medium | Sprint A4 — add widget tests |

# TODOS

## Security

_No open security items._

## Testing

### P1: `_globalRedirect` auth gate branches need integration tests

**What:** The 5 redirect branches in `_globalRedirect` (`lib/config/router/app_router.dart:304`) have zero test coverage. The magic-link+onboarding redirect loop fix (this branch) changed this function and has no regression test.

**Why:** GoRouter redirect bugs cause visible crashes. The loop was caught manually — a regression test would have caught it automatically.

**Context:** Branches to cover: (1) `magicLinkDone=false` + not on `/magic-link` → redirect to `/magic-link`; (2) `magicLinkDone=false` + on `/magic-link` → stay (null); (3) `magicLinkDone=true` + on `/magic-link` → redirect to `/home`; (4) `onboardingDone=false` + protected path → `/welcome`; (5) Hive box closed → `/pin-entry`; (6) PIN not set up → `/pin-setup`; (7) session not authenticated → `/pin-entry`.

**Effort:** M  
**Priority:** P1  
**Depends on:** None

---

### P1: PinEntryScreen and PinSetupScreen need widget tests

**What:** Both PIN screens (`lib/features/auth/presentation/views/pin_entry_screen.dart`, `pin_setup_screen.dart`) have zero test coverage. Lockout logic, attempt counter, and mismatch-reset branch are untested.

**Why:** PIN is the primary local authentication mechanism. Untested lockout/mismatch branches are where security bugs hide.

**Context:** Noted in `/ship` pre-landing review on `feat/ui-ux-migration`. Key scenarios: correct PIN authenticates and navigates; wrong PIN shows remaining-attempts message; 5th wrong attempt triggers lockout; locked state hides numpad; PIN mismatch in setup resets to step 1; clear button works.

**Effort:** M  
**Priority:** P1  
**Depends on:** None

---

### P2: HelmTrustStrip and HelmFxEstimate widget tests

**What:** `HelmTrustStrip._formatTime` (3 branches: just now / N min ago / formatted time) and `HelmFxEstimate` (null fxRate vs fxRate provided) have zero test coverage.

**Why:** Trust strip is a high-visibility component on the dashboard. Format branch bugs would show up as silent wrong labels.

**Context:** Pre-existing gap noted in `/ship` review. Low risk since logic is simple, but the null-fxRate branch in `HelmFxEstimate` is the "FX rate not set" error state.

**Effort:** S  
**Priority:** P2  
**Depends on:** None

### P1: logout() path needs integration test for Hive + SharedPrefs cleanup

**What:** `logout()` in `auth_provider.dart` now clears 4 values (session token, `magic_link_verified`, magic-link flag, `guest_mode`). There is no test verifying all 4 are cleared.

**Why:** A partial clear leaves the user in a split-identity state (Hive says verified, SharedPrefs says not, or vice versa). The cross-validation gate would then loop to magic-link on every cold start.

**Effort:** S  
**Priority:** P1  
**Depends on:** None

---

## Completed

_None yet._

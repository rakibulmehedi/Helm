# TODOS

## Security

### P0: Guest mode security scope — document intent or add flag

**What:** `onGuest` callback in `app_router.dart:154` sets `magicLinkAuthCompleted=true` and navigates to home, bypassing identity verification. User still hits PIN gate, but the magic-link trust layer is skipped by design.

**Why:** The magic-link gate comment says "Identity verification must run before any user data collection." Guest mode contradicts this. Either the comment is wrong, or guest mode needs a separate flag (`guestMode=true`) so sensitive routes can restrict guest access.

**Context:** Discovered during `/ship` pre-landing review on branch `feat/ui-ux-migration`. The `onGuest` callback was added in the Signal Deck merge from `main`. Decision needed: (A) guest = full local access, PIN-protected only — document this as intentional; (B) guest = restricted access (no export, no audit log, no delete account) — add `guestMode` flag and route guards.

**Effort:** S  
**Priority:** P0  
**Depends on:** Founder decision on guest mode scope

---

### P1: `magicLinkAuthCompleted` in plaintext SharedPreferences

**What:** The magic-link gate relies on a plaintext `SharedPreferences` boolean. A local attacker with device access or backup restore can set this flag without completing verification.

**Why:** For a trust-layer that the architecture treats as mandatory ("identity verification must run before any user data collection"), a spoofable plaintext flag provides weak enforcement.

**Context:** For a local-first app where all user data is on-device, the threat model may make this acceptable (attacker with device access already has data). If the magic-link gate is purely UX friction rather than a security boundary, document this. If it is a security boundary, move to `flutter_secure_storage` or cross-validate against a Hive session token.

**Effort:** M  
**Priority:** P1  
**Depends on:** Guest mode scope decision above

---

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

## Completed

_None yet._

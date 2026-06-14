# Go / No-Go Criteria

> Decision framework for Helm closed beta launch and post-beta V1 decision.
> Authority: Final Product Doctrine S16

---

## Part 1: Pre-Beta Go/No-Go (Can We Ship the Beta?)

### Technical Prerequisites

| # | Criterion | Status | Required |
|---|-----------|--------|----------|
| T1 | dart analyze: 0/0/0 | PASS | Yes |
| T2 | flutter test: all pass | PASS (38/38) | Yes |
| T3 | No Hive TypeId conflicts | PASS | Yes |
| T4 | No dead/broken routes | PASS | Yes |
| T5 | PIN auth functional | PASS | Yes |
| T6 | Account deletion functional | PASS (bug fixed D3) | Yes |
| T7 | CSV export functional | PASS | Yes |
| T8 | S2S calculation correct | PASS | Yes |
| T9 | Release build runs on device | UNTESTED | Yes |
| T10 | No known crash paths | PASS | Yes |

### Product Prerequisites

| # | Criterion | Status | Required |
|---|-----------|--------|----------|
| P1 | Onboarding captures liquid balance | PASS | Yes |
| P2 | Onboarding captures fixed costs | PASS | Yes |
| P3 | Onboarding captures buffer % | PASS | Yes |
| P4 | S2S visible on dashboard | PASS | Yes |
| P5 | Income pipeline CRUD works | PASS | Yes |
| P6 | Status transitions work | PASS | Yes |
| P7 | Expense CRUD works | PASS | Yes |
| P8 | Breakdown drawer shows math | PASS | Yes |
| P9 | Audit log captures writes | PASS | Yes |
| P10 | Analytics events fire (local) | PASS | Yes |

### Operational Prerequisites

| # | Criterion | Status | Required |
|---|-----------|--------|----------|
| O1 | Manual QA script completed | PENDING | Yes |
| O2 | Tester cohort recruited (15-25) | PENDING | Yes |
| O3 | Feedback channel created | PENDING | Yes |
| O4 | Tester onboarding script ready | PASS | Yes |
| O5 | Founder observation sheet ready | PASS | Yes |
| O6 | Beta validation protocol ready | PASS | Yes |

### Pre-Beta Verdict

**Technical**: GO (pending T9 release build verification)
**Product**: GO
**Operational**: PENDING (O1, O2, O3 need completion)

**Overall Pre-Beta**: CONDITIONAL GO -- complete manual QA on device, recruit testers, create feedback channel.

---

## Part 2: Post-Beta Go/No-Go (Can We Ship V1?)

### Doctrine S16 Mandatory Thresholds

| # | Metric | Target | Kill If | Weight |
|---|--------|--------|---------|--------|
| M1 | Pipeline update compliance | >= 85% | < 70% | Critical |
| M2 | Override-equivalent rate | < 5% | >= 15% | High |
| M3 | 30-day retention | >= 60% | < 40% | Critical |
| M4 | Onboarding completion | >= 70% | < 50% | High |
| M5 | S2S comprehension | >= 80% | < 60% | Critical |

### Decision Matrix

| Thresholds Met | Thresholds Missed | Decision | Action |
|----------------|-------------------|----------|--------|
| 5/5 | 0 | **STRONG GO** | Proceed to V1. Ship with confidence. |
| 4/5 | 1 | **CONDITIONAL GO** | Identify weak metric. Fix root cause. Run 2-week patch beta to revalidate. |
| 3/5 | 2 | **NO-GO** | Per Doctrine: Do not ship V1. Deep analysis required. |
| 2/5 or fewer | 3+ | **KILL** | Product hypothesis invalidated. Sunset or pivot. |

### Qualitative Gates (Founder Judgment)

Even if metrics pass, consider NO-GO if:
- Multiple testers say "I prefer my spreadsheet"
- Zero testers would miss Helm if removed
- Feature requests indicate fundamental misalignment with product
- Trust in S2S number is low despite comprehension being high
- Testers maintain pipeline only because they're asked to (observer effect)

Even if one metric misses, consider CONDITIONAL GO if:
- Miss is marginal (within 5% of target)
- Root cause is identifiable and fixable
- Qualitative signals are strongly positive
- Testers express genuine disappointment if product disappeared

---

## Part 3: Known Acceptable Gaps for Beta

These are explicitly NOT blockers for beta launch:

| Gap | Why Acceptable | When to Address |
|-----|---------------|-----------------|
| No biometric auth | Many budget Android phones lack hardware; PIN sufficient | V1 |
| No Magic Link auth | Requires backend decision; PIN-only for beta | V1 |
| History tab placeholder | Not core to S2S validation hypothesis | Post-beta |
| No transaction undo | Expenses can be edited/deleted; pipeline has undo | Post-beta |
| Minimal test coverage | Manual QA compensates for beta; add tests pre-V1 | Pre-V1 |
| No legal disclaimers | Add before public release; beta testers are informed | Pre-V1 |
| Feature files use legacy tokens | Functional via re-export; visual parity maintained | Post-beta |
| No push notifications | Offline-first; testers check manually | V1 |
| No dark mode polish | System dark mode works but may have rough edges | Post-beta |
| No Bangla localization | Beta testers are English-comfortable freelancers | Post-beta |

---

## Decision Record Template

```
Date: ________
Sprint: D3 Closed Beta Readiness
Decision: GO / CONDITIONAL GO / NO-GO / KILL

Metrics:
- M1 Pipeline compliance: ___% (target >= 85%)
- M2 Override rate: ___% (target < 5%)
- M3 30-day retention: ___% (target >= 60%)
- M4 Onboarding completion: ___% (target >= 70%)
- M5 S2S comprehension: ___% (target >= 80%)

Thresholds met: ___/5
Thresholds missed: ___

Qualitative assessment:
_______________

Decision rationale:
_______________

Next action:
_______________

Decided by: ________
```

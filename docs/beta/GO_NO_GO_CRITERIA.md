# Go / No-Go Criteria

> Decision framework for post-beta V1 decision.
> Authority: Final Product Doctrine S16

---

## Post-Beta Go/No-Go (Can We Ship V1?)

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


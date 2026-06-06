# Known Limitations

> Documented limitations for Pocketa closed beta release.
> These are NOT blockers. Each has been evaluated and accepted for beta.
> Date: 2026-06-06

---

## Functional Limitations

### L1: History Tab is Placeholder
- **Screen**: /history route shows `_HistoryPlaceholder` widget
- **Impact**: Testers cannot view transaction history in dedicated screen
- **Workaround**: Audit log (Settings > Change History) shows all financial events
- **When to fix**: Post-beta (UX-3 scope)

### L2: No Biometric Authentication
- **What**: Only 4-digit PIN available; no fingerprint/face unlock
- **Why deferred**: Requires `local_auth` package approval (Decision 025)
- **Impact**: Slightly slower unlock vs biometric; security level adequate for beta
- **When to fix**: V1

### L3: No Magic Link Authentication
- **What**: No email-based login; PIN is the only auth mechanism
- **Why deferred**: Requires backend decision -- Supabase vs Next.js+Postgres (Doctrine S14)
- **Impact**: No account recovery if PIN forgotten; beta testers must remember PIN
- **Workaround**: Testers can delete account and re-onboard if locked out
- **When to fix**: V1

### L4: No Transaction Undo/Confirm Workflow
- **What**: Expenses have add/edit/delete but no "confirm" state or undo-after-save
- **Impact**: Accidental expense entries must be manually edited or deleted
- **Workaround**: Edit or delete the expense entry
- **Note**: `undoConfirmUsed` event constant exists but is unwired
- **When to fix**: Post-beta

### L5: No Push Notifications
- **What**: App does not send reminders to update pipeline
- **Impact**: Testers must self-motivate to open app daily
- **Why acceptable**: Beta tests whether manual discipline is sustainable (core hypothesis)
- **When to fix**: V1 (transactional only per Doctrine)

### L6: No "---" Fallback on S2S Calculation Failure
- **What**: If S2S calculation somehow fails, shows 0 instead of em-dash
- **Impact**: Unlikely in practice (all inputs have defaults); could mislead if triggered
- **When to fix**: Pre-V1

---

## Visual / UX Limitations

### L7: Feature Screens Use Legacy Design Tokens
- **What**: Feature files reference `AppColors.*` via legacy re-export, not new `PocketaColors`
- **Impact**: Visual parity maintained through re-export shim; no user-visible difference
- **When to fix**: Gradual migration post-beta

### L8: Dark Mode May Have Rough Edges
- **What**: System dark mode triggers theme switch; some screens may have suboptimal contrast
- **Impact**: Functional but possibly less polished in dark mode
- **When to fix**: Post-beta polish pass

### L9: No Bangla Localization
- **What**: All UI text is in English
- **Impact**: Beta testers are English-comfortable freelancers; no impact on target cohort
- **When to fix**: Post-beta, pre-public release

### L10: No First-Run Animation
- **What**: Splash screen is static; no branded animation or motion
- **Impact**: Minor polish gap; no functional impact
- **When to fix**: V1

### L11: No S2S Hint Tooltip
- **What**: No contextual tooltip explaining S2S on first dashboard view
- **Impact**: Testers learn S2S meaning through onboarding and check-in; no in-app education
- **When to fix**: Post-beta

---

## Data / Privacy Limitations

### L12: No Cloud Backup
- **What**: All data is device-local only; no sync or backup
- **Impact**: Phone loss = data loss; testers are informed of this
- **Workaround**: CSV export creates a portable backup
- **When to fix**: V1+ (requires backend decision)

### L13: No "Not Financial Advice" Disclaimer
- **What**: App does not display legal disclaimer on S2S screen
- **Impact**: Acceptable for private beta; must add before any public distribution
- **When to fix**: Pre-V1 public release

### L14: Analytics Are Local Only
- **What**: All analytics events go to debugPrint; no remote collection
- **Impact**: Founder cannot see tester behavior remotely; relies on CSV exports and check-ins
- **Why acceptable**: Privacy-first for beta; validates with manual observation
- **When to fix**: Post-beta (swap LocalAnalyticsService for remote adapter)

---

## Technical Limitations

### L15: Minimal Automated Test Coverage
- **What**: 2 test files (38 tests): PinHasher unit tests + S2S calculator unit tests
- **Impact**: No automated smoke tests for UI flows; manual QA compensates
- **When to fix**: Pre-V1 (add widget tests for critical flows)

### L16: Categories Are Placeholder Strings
- **What**: Expense categories are hardcoded strings, not dynamic/user-editable
- **Impact**: Adequate for beta (covers common categories); not extensible
- **When to fix**: Post-beta

### L17: No Formal Wallet Model
- **What**: Single implicit wallet; no multi-wallet support
- **Impact**: Beta scope is single-wallet only per Doctrine
- **When to fix**: V1 (multi-wallet deferred per Decision 019)

---

## Limitation Severity Summary

| Severity | Count | IDs |
|----------|-------|-----|
| Non-blocking, cosmetic | 5 | L7, L8, L10, L11, L16 |
| Non-blocking, functional gap | 6 | L1, L4, L5, L6, L14, L15 |
| Deferred by design | 4 | L2, L3, L12, L17 |
| Pre-V1 required | 2 | L6, L13 |
| Pre-public required | 1 | L9 |

**Total limitations**: 17
**Beta blockers**: 0

# POCKETA — Feature Specification Template

> Use this template when requesting a new feature phase.
> Copy, fill in, and hand to the implementing agent.

---

## Feature: [Feature Name]

### Phase: [N]

### Goal
[One-sentence description of what this phase accomplishes.]

---

### Implement

1. [Specific deliverable 1]
2. [Specific deliverable 2]
3. [Specific deliverable 3]
...

---

### Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] `dart analyze` clean
- [ ] Existing features not broken

---

### Scope Guardrails

Do NOT:
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]
- [Explicitly excluded item 3]

---

### Technical Notes

[Optional: architectural hints, preferred patterns, relevant existing code to reuse.]

---

### Expected Deliverables

After implementation, provide:

```markdown
# Phase N — [Feature Name] Complete

## 1. Summary
## 2. Files Created
## 3. Files Modified
## 4. Data Flow
## 5. State Flow
## 6. UX Impact
## 7. Analyzer Result
## 8. Suggested Git Commit Message
```

---

## Example Usage

```markdown
## Feature: Income Pipeline

### Phase: 7

### Goal
Add the ability to track pending, escrow, and cleared income to reduce freelancer cashflow anxiety.

### Implement
1. Add pending and cleared status flags to Transaction model.
2. Build UI to show expected income timeline.
3. Update summary cards to show "Safe-to-Spend" balance.

### Acceptance Criteria
- [ ] Dashboard shows pending vs cleared income
- [ ] Safe-to-Spend balance updates correctly
- [ ] Dark mode compatible
- [ ] dart analyze clean

### Scope Guardrails
Do NOT:
- Add complex invoicing PDF generation
- Redesign dashboard layout
- Add cloud sync
```

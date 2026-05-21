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
## Feature: Charts & Spending Visualization

### Phase: 7

### Goal
Add visual spending insights to the dashboard.

### Implement
1. Add monthly spending bar chart.
2. Add income vs expense comparison.
3. Add category breakdown donut chart.
4. Use fl_chart package (approved).

### Acceptance Criteria
- [ ] Dashboard shows spending chart
- [ ] Chart updates when transactions change
- [ ] Dark mode compatible
- [ ] dart analyze clean

### Scope Guardrails
Do NOT:
- Add budget logic
- Redesign dashboard layout
- Add cloud sync
```

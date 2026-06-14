# HELM — Review Checklist

> Use this checklist before approving any phase or committing changes.
> Applies to both human reviewers and AI self-review.

---

## Pre-Commit Checklist

### Code Quality
- [ ] `dart analyze` returns 0 errors, 0 warnings, 0 infos
- [ ] No `print()` statements left in production code
- [ ] No `TODO` comments without tracking (acceptable during active development)
- [ ] No hardcoded colors — all colors use `AppColors`
- [ ] No deprecated APIs (`withOpacity` → `withValues`)
- [ ] All `setState` calls guarded with `mounted` check
- [ ] All async navigation guarded with `mounted` check

### Architecture
- [ ] New files placed in correct directory per feature-first structure
- [ ] No circular dependencies between features
- [ ] No direct Hive calls from presentation layer
- [ ] Repository pattern followed (abstract → impl)
- [ ] Providers wired correctly through Riverpod

### Naming
- [ ] Files use `snake_case`
- [ ] Classes use `PascalCase` with correct suffix (Screen, Model, Provider, etc.)
- [ ] Providers use `camelCase` with `Provider` suffix

### UX
- [ ] Changes render correctly in both light and dark mode
- [ ] No overflow on small screens (320px width minimum)
- [ ] User feedback provided for all actions (SnackBar, loading states)
- [ ] Error states handled gracefully
- [ ] Empty states handled where applicable

### Scope
- [ ] Only implements what was requested in the phase spec
- [ ] No features from future phases
- [ ] No package additions without approval
- [ ] No unrelated refactoring

### Persistence
- [ ] Hive operations are async and properly awaited
- [ ] Box names use constants from `app_box_names.dart`
- [ ] No data loss scenarios on common operations

### Routing
- [ ] New routes added to `app_router.dart`
- [ ] Route names added to `route_names.dart`
- [ ] Navigation uses named routes
- [ ] Back navigation works correctly

### Git
- [ ] Commit message follows `type(scope): description` format
- [ ] One logical change per commit
- [ ] No generated files committed without source
- [ ] Commit description lists key changes

---

## Phase Completion Checklist

- [ ] All acceptance criteria from the phase spec are met
- [ ] Completion report delivered in standard format
- [ ] No regressions in existing features
- [ ] Chief Architect has reviewed and approved
- [ ] Changes committed with proper message
- [ ] Roadmap updated if applicable

---

## Common Red Flags

| Red Flag | Action |
|---|---|
| File > 300 lines | Consider extracting widgets/helpers |
| More than 5 imports from `data/` layer | Check dependency direction |
| `context` used after `await` without `mounted` | Add mounted guard |
| New package in `pubspec.yaml` | Requires Chief Architect approval |
| Modified file not in phase scope | Revert unless fixing broken dependency |
| Analyzer warnings suppressed with `// ignore` | Remove and fix properly |

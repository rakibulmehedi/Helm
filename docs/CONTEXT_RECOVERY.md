# CONTEXT RECOVERY

> Protocol for agents to regain context after a long break, context window reset, or when picking up another agent's work.

## 1. Context Recovery Process
- Do NOT assume context from previous sessions.
- Do NOT hallucinate project state.
- Follow the steps below systematically.

## 2. Mandatory Files to Reread
1. `docs/POCKETA_BRAIN.md`
2. `docs/ARCHITECTURE_RULES.md`
3. `docs/ROADMAP.md`
4. `docs/CURRENT_SPRINT.md`
5. `docs/PROJECT_STATE.md`

## 3. Architecture Recovery Steps
- Check `pubspec.yaml` for current dependencies.
- Review `lib/core/` and `lib/features/` directory structures to understand existing domains.
- Read recent commits (`git log -n 5`) to understand the latest changes.

## 4. Product Identity Recovery
- Remind yourself: *"Pocketa is a Freelancer Finance OS for emerging Bangladeshi earners."*
- Ensure any upcoming work aligns with this specific demographic and use case.

## 5. Known Frozen Systems
- DO NOT attempt to redesign:
  - transaction provider structure
  - Hive architecture
  - routing structure
  - localization system

# agents
- Keep agent definition files (.claude/agents/*.md) general-purpose and reusable — do not hardcode project-specific details into agent definitions. Apply agents as lenses to the codebase instead of rewriting agents for the codebase. Confidence: 0.75

# documentation
- When a planning or analysis document is created, update the operational tracking docs (ROADMAP.md, PROJECT_STATE.md, CURRENT_SPRINT.md) to reflect it — analysis documents must be operationalized into execution tracking. Confidence: 0.70
- Dispatch/planning documents should be split per phase, not consolidated into one monolithic file — keep each phase's dispatch plan in its own separate document. Confidence: 0.70

# git
- Commit changes sequentially in small, logical micro-commits rather than bundling everything into one large commit. Confidence: 0.65

# flutter
- Prefer native Android/iOS development over Flutter when build infrastructure issues arise. Confidence: 0.50

# Taste (Continuously Learned by [CommandCode][cmd])

[cmd]: https://commandcode.ai/

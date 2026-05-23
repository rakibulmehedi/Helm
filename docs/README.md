# Pocketa Documentation Index

All documentation for Pocketa lives here. This index makes it navigable.

Documentation is the active operating memory of the product — not an archive.

---

## Core

Foundational documents every contributor must read before touching the codebase.

| Document | Purpose |
|---|---|
| [POCKETA_BRAIN.md](core/POCKETA_BRAIN.md) | Product identity, philosophy, target user, emotional contract |
| [ARCHITECTURE_RULES.md](core/ARCHITECTURE_RULES.md) | Hard technical constraints, naming conventions, forbidden patterns |
| [ROADMAP.md](core/ROADMAP.md) | Phase history, current direction, strategic priorities |

---

## Governance

How engineering agents and contributors are expected to operate.

| Document | Purpose |
|---|---|
| [AGENT_WORKFLOW.md](governance/AGENT_WORKFLOW.md) | Execution protocol for AI agents and contributors |
| [ANTI_PATTERNS.md](governance/ANTI_PATTERNS.md) | Patterns that are explicitly forbidden |
| [ESCALATION_RULES.md](governance/ESCALATION_RULES.md) | When to escalate vs. proceed autonomously |
| [REVIEW_CHECKLIST.md](governance/REVIEW_CHECKLIST.md) | Pre-commit and pre-merge review checklist |
| [CONTEXT_RECOVERY.md](governance/CONTEXT_RECOVERY.md) | How to recover context after session loss |
| [SESSION_START_PROTOCOL.md](governance/SESSION_START_PROTOCOL.md) | Session initialization steps |
| [SESSION_END_PROTOCOL.md](governance/SESSION_END_PROTOCOL.md) | Session close-out steps |

---

## Specs

Product feature specifications. Implementations must reference a spec.

| Document | Feature |
|---|---|
| [SAFE_TO_SPEND_MODEL.md](specs/SAFE_TO_SPEND_MODEL.md) | Safe-to-Spend formula — locked contract |
| [INCOME_PIPELINE_MVP.md](specs/INCOME_PIPELINE_MVP.md) | Freelancer income pipeline MVP |
| [PHASE_7_FREELANCER_INCOME_TRACKING.md](specs/PHASE_7_FREELANCER_INCOME_TRACKING.md) | Phase 7 income tracking spec |
| [SUBSCRIPTION_LEAKAGE_RADAR.md](specs/SUBSCRIPTION_LEAKAGE_RADAR.md) | Phase 9 concept (conditional on validation) |
| [VIRTUAL_WALLETS.md](specs/VIRTUAL_WALLETS.md) | Future phase concept |

---

## Implementation

Execution plans, file maps, state flows, and acceptance checklists per phase.

| Document | Phase |
|---|---|
| [PHASE_7_EXECUTION_PLAN.md](implementation/PHASE_7_EXECUTION_PLAN.md) | Phase 7 execution plan |
| [PHASE_7_FILE_MAP.md](implementation/PHASE_7_FILE_MAP.md) | Phase 7 authoritative file map |
| [PHASE_7_STATE_FLOW.md](implementation/PHASE_7_STATE_FLOW.md) | Phase 7 state transitions |
| [PHASE_7_RISKS.md](implementation/PHASE_7_RISKS.md) | Phase 7 risk register |
| [PHASE_7_ACCEPTANCE_CHECKLIST.md](implementation/PHASE_7_ACCEPTANCE_CHECKLIST.md) | Phase 7 acceptance criteria |
| [PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md](implementation/PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md) | Phase 8 execution plan |
| [PHASE_8_ACCEPTANCE_CHECKLIST.md](implementation/PHASE_8_ACCEPTANCE_CHECKLIST.md) | Phase 8 acceptance criteria |

---

## Architecture

Database, migration, and system design documents.

| Document | Topic |
|---|---|
| [LOCAL_DATABASE_DECISION_REVIEW.md](architecture/LOCAL_DATABASE_DECISION_REVIEW.md) | Hive vs Drift audit and decision rationale |
| [HIVE_TO_DRIFT_MIGRATION_OPTIONS.md](architecture/HIVE_TO_DRIFT_MIGRATION_OPTIONS.md) | Migration path options |
| [HIVE_TYPEID_REGISTRY.md](architecture/HIVE_TYPEID_REGISTRY.md) | Hive type ID registry (required reading before adding models) |

---

## Research

Background research that informed product and architecture decisions.

| Document | Topic |
|---|---|
| [FREELANCER_CASHFLOW_RESEARCH.md](research/FREELANCER_CASHFLOW_RESEARCH.md) | Freelancer cashflow patterns and pain points |
| [BEHAVIORAL_FINANCE_RESEARCH.md](research/BEHAVIORAL_FINANCE_RESEARCH.md) | Behavioral economics applied to money management |
| [USER_PSYCHOLOGY.md](research/USER_PSYCHOLOGY.md) | Psychological model behind the product |
| [SAFE_TO_SPEND_MODEL.md](research/SAFE_TO_SPEND_MODEL.md) | Original Safe-to-Spend model research |
| [PRODUCT_STRATEGY_ANALYSIS.md](research/PRODUCT_STRATEGY_ANALYSIS.md) | Competitive and strategic analysis |
| [SAAS_LEAKAGE_RESEARCH.md](research/SAAS_LEAKAGE_RESEARCH.md) | SaaS subscription leakage research |
| [BRUTAL_AUDIT_VALIDATION.md](research/BRUTAL_AUDIT_VALIDATION.md) | Brutal product audit findings |

---

## QA

Test checklists, scenario matrices, and simulated QA reports.

| Document | Purpose |
|---|---|
| [PHASE_8_SIMULATED_QA_REPORT.md](qa/PHASE_8_SIMULATED_QA_REPORT.md) | Simulated QA for Phase 8 |
| [PHASE_8_REAL_DEVICE_QA_CHECKLIST.md](qa/PHASE_8_REAL_DEVICE_QA_CHECKLIST.md) | Manual real-device QA checklist |
| [SAFE_TO_SPEND_SCENARIO_MATRIX.md](qa/SAFE_TO_SPEND_SCENARIO_MATRIX.md) | Formula edge case scenario matrix |

---

## Validation

User interview questions, validation scripts, and success metrics.

| Document | Purpose |
|---|---|
| [FOUNDER_VALIDATION_SCRIPT.md](validation/FOUNDER_VALIDATION_SCRIPT.md) | Founder-led user interview script |
| [FREELANCER_USER_INTERVIEW_QUESTIONS.md](validation/FREELANCER_USER_INTERVIEW_QUESTIONS.md) | Structured interview questions |
| [VALIDATION_METRICS.md](validation/VALIDATION_METRICS.md) | Metrics for assessing product-market fit |

---

## Tracking

Living tracking documents. Updated after every meaningful change.

| Document | Purpose |
|---|---|
| [PROJECT_STATE.md](tracking/PROJECT_STATE.md) | Current architecture and module completion state |
| [CURRENT_SPRINT.md](tracking/CURRENT_SPRINT.md) | Active sprint, priorities, and sprint status table |
| [TASKS.md](tracking/TASKS.md) | Granular task list |
| [DECISION_LOG.md](tracking/DECISION_LOG.md) | All major architectural and product decisions |
| [LESSONS.md](tracking/LESSONS.md) | Important mistakes and discoveries |

---

## Planning

Strategic and execution planning documents.

| Document | Purpose |
|---|---|
| [POST_AUDIT_EXECUTION_ROADMAP.md](planning/POST_AUDIT_EXECUTION_ROADMAP.md) | Strategic roadmap post brutal audit |

---

## Templates

| Document | Purpose |
|---|---|
| [FEATURE_SPEC_TEMPLATE.md](templates/FEATURE_SPEC_TEMPLATE.md) | Template for new feature specs |

---

## Status

See [STATUS.md](STATUS.md) for current product and engineering status.

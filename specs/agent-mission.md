# Agent Mission

**Agent Mission** is the durable purpose statement that defines why an agent, system, team, or operator fabric exists and what outcomes it is responsible for pursuing.

It is not just a goal. It is a **governed purpose that generates objectives, desired states, contracts, policies, and commands**.

```txt
Agent Mission =
  Purpose
+ Principal
+ Scope
+ Outcomes
+ Success Criteria
+ Boundaries
+ Constraints
+ Desired States
+ Metrics
+ Review Cadence
+ Termination Conditions
```

## Definition

An **Agent Mission** defines the reason an agent or operator system exists.

It tells the operator fabric:

1. who the mission serves
2. what purpose the mission advances
3. what outcomes must be pursued
4. what boundaries must not be crossed
5. what desired states should be produced
6. how success is measured
7. which contracts and policies may be derived from it
8. when the mission should be reviewed, suspended, or terminated

## Canonical Shape

```json
{
  "kind": "AgentMission",
  "version": "0.1.0",
  "id": "mission_001",
  "name": "Agent Operator Canonical Model Mission",
  "purpose": "Define a governed operator vocabulary for agentic systems so actions can be authorized, executed, observed, evidenced, and reconciled.",
  "principal": {
    "type": "organization",
    "id": "org:AGenNext",
    "role": "mission_owner"
  },
  "scope": {
    "domains": [
      "agent_operations",
      "governance",
      "policy",
      "reconciliation",
      "auditability"
    ],
    "targets": [
      "github:AGenNext/Agent-As-A-Operator"
    ],
    "excluded": [
      "unbounded_autonomy",
      "policy_bypass",
      "unverified_execution"
    ]
  },
  "outcomes": [
    {
      "id": "outcome_001",
      "statement": "Every agent action can be expressed as a governed command, decision, event, evidence object, state, and reconciliation loop."
    },
    {
      "id": "outcome_002",
      "statement": "Agent operations remain auditable, policy-bound, and contract-authorized."
    }
  ],
  "success_criteria": [
    "canonical_specs_published",
    "schemas_are_machine_readable",
    "operator_workflows_are_traceable",
    "reconciliation_paths_are_defined",
    "evidence_is_required_for_trusted_state"
  ],
  "boundaries": {
    "must_obey": [
      "human_authority_remains_explicit",
      "policy_must_be_enforceable",
      "evidence_must_support_trust",
      "state_must_be_reconcilable"
    ],
    "must_not": [
      "grant_unbounded_authority",
      "hide_decision_basis",
      "treat_claims_as_facts_without_evidence"
    ]
  },
  "desired_states": [
    {
      "type": "repository_state",
      "status": "published",
      "artifacts": [
        "specs/agent-command.md",
        "specs/agent-event.md",
        "specs/agent-decision.md",
        "specs/agent-contract.md",
        "specs/agent-policy.md",
        "specs/agent-evidence.md",
        "specs/agent-reconciliation.md",
        "specs/agent-state.md",
        "specs/agent-mission.md"
      ]
    }
  ],
  "metrics": [
    {
      "name": "published_spec_count",
      "target": 9
    },
    {
      "name": "governed_object_coverage",
      "target": "command_to_reconciliation_chain_complete"
    }
  ],
  "review": {
    "cadence": "on_major_model_change",
    "reviewers": ["mission_owner", "policy_operator", "governance_authority"]
  },
  "termination_conditions": [
    "mission_replaced_by_newer_constitutional_model",
    "governance_authority_withdraws_scope",
    "core_operator_vocabulary_is_deprecated"
  ]
}
```

## Natural-Language Form

```txt
For <principal>,
pursue <purpose>
within <scope>,
produce <outcomes and desired states>,
measure <success criteria and metrics>,
respect <boundaries>,
and review or terminate under <conditions>.
```

Example:

```txt
For AGenNext,
pursue a canonical operator vocabulary for agentic systems,
within governance, policy, auditability, and reconciliation scope,
produce published specs and machine-readable schemas,
measure success by complete command-to-reconciliation coverage,
respect human authority, policy enforcement, and evidence requirements,
and review the mission when the model changes.
```

## Agent Mission vs Goal

| Goal | Agent Mission |
|---|---|
| Usually narrow | Durable purpose |
| Can be completed once | Governs many objectives over time |
| May not define boundaries | Defines boundaries and exclusions |
| May not produce contracts | Generates contracts, policies, and desired states |
| Often measured by completion | Measured by sustained alignment |
| Tactical | Strategic and constitutional-facing |

## Core Rule

```txt
A goal says what to achieve.
A mission says why the system exists.
A mission gives purpose to contracts, policies, commands, and states.
```

## Minimal TypeScript Schema

```ts
type AgentMission = {
  kind: "AgentMission";
  version: string;
  id: string;
  name: string;
  purpose: string;

  principal: {
    type: "human" | "organization" | "system" | string;
    id: string;
    role?: string;
  };

  scope: {
    domains?: string[];
    targets?: string[];
    excluded?: string[];
  };

  outcomes: Array<{
    id: string;
    statement: string;
  }>;

  success_criteria?: string[];

  boundaries?: {
    must_obey?: string[];
    must_not?: string[];
  };

  desired_states?: Array<Record<string, unknown>>;

  metrics?: Array<{
    name: string;
    target?: string | number | boolean;
  }>;

  review?: {
    cadence?: string;
    reviewers?: string[];
  };

  termination_conditions?: string[];
};
```

## Runtime Position

```txt
Agent Constitution
        ↓
Agent Mission
        ↓
Objectives / Desired States
        ↓
Agent Contract
        ↓
Agent Policy
        ↓
Agent Command
        ↓
Agent Decision
        ↓
Agent Event
        ↓
Agent Evidence
        ↓
Agent State
        ↓
Agent Reconciliation
```

## Final Definition

**Agent Mission is the governed purpose layer that defines why an agent system exists and which outcomes its contracts, policies, commands, states, and reconciliation loops must serve.**

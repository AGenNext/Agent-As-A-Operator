# Agent Decision

**Agent Decision** is the governed explanation of why an agent, policy engine, human, or system selected one action, state, or outcome over another.

It is not just a result. It is a **traceable reasoned choice**.

```txt
Agent Decision =
  Decision Type
+ Decider
+ Subject
+ Inputs
+ Options Considered
+ Policy Basis
+ Reasoning Summary
+ Outcome
+ Evidence
+ Confidence
+ Approval State
+ Trace
```

## Definition

An **Agent Decision** records why a command was accepted, rejected, escalated, executed, retried, rolled back, or reconciled.

It tells the operator fabric:

1. what decision was made
2. who or what made the decision
3. what command, event, or state it applies to
4. what inputs and evidence were considered
5. what alternatives were available
6. what policies or constraints governed the choice
7. what outcome was selected
8. whether approval was required
9. how the decision can be audited later

## Canonical Shape

```json
{
  "kind": "AgentDecision",
  "version": "0.1.0",
  "id": "dec_001",
  "type": "agent.command.approved",
  "time": "2026-06-07T00:00:00Z",
  "decider": {
    "type": "agent",
    "id": "agent:operator",
    "role": "policy_operator"
  },
  "subject": {
    "type": "AgentCommand",
    "id": "cmd_001"
  },
  "inputs": {
    "commands": ["cmd_001"],
    "events": ["evt_001"],
    "policies": ["policy:publish_requires_evidence"],
    "context_refs": ["trace://trace_001/context"]
  },
  "options_considered": [
    {
      "option": "approve",
      "status": "selected",
      "reason": "command satisfied policy, tool scope, and evidence requirements"
    },
    {
      "option": "reject",
      "status": "not_selected",
      "reason": "no blocking violation found"
    },
    {
      "option": "escalate",
      "status": "not_selected",
      "reason": "human approval was not required for this documentation-only publish"
    }
  ],
  "policy_basis": {
    "engine": "opa",
    "rules": [
      "do_not_delete_existing_work",
      "preserve_provenance",
      "require_validation_log"
    ]
  },
  "reasoning_summary": "The command was documentation-only, used an allowed GitHub create-file operation, preserved existing work, and produced commit evidence.",
  "outcome": {
    "status": "approved",
    "next_state": "execution_allowed"
  },
  "evidence": {
    "items": [
      {
        "type": "commit_sha",
        "value": "1038dc1365293e22b565bda75268b4e81f9ded00"
      }
    ]
  },
  "confidence": {
    "score": 0.97,
    "basis": "policy pass and successful repository write"
  },
  "approval": {
    "required": false,
    "status": "not_required"
  },
  "trace": {
    "trace_id": "trace_001",
    "span_id": "span_decision_001"
  }
}
```

## Natural-Language Form

```txt
For <subject>,
<decider> chose <outcome>
from <options considered>
based on <inputs, evidence, and policy>
with <confidence>
under <approval state>
and recorded <trace>.
```

Example:

```txt
For Agent Command cmd_001,
the Operator Agent chose approval
from approve, reject, or escalate
based on policy, allowed tools, and commit evidence
with high confidence
without requiring additional approval
and recorded trace_001.
```

## Agent Decision vs Result

| Result | Agent Decision |
|---|---|
| Says what happened | Explains why it happened |
| May be final only | Includes options considered |
| Often lacks policy basis | Anchored to policy and constraints |
| May not be auditable | Audit-ready |
| Output-oriented | Governance-oriented |
| Ends a task | Can trigger the next governed state |

## Core Rule

```txt
An event says what changed.
A decision says why that change was allowed.
An agent decision binds reasoning to governance.
```

## Minimal TypeScript Schema

```ts
type AgentDecision = {
  kind: "AgentDecision";
  version: string;
  id: string;
  type: string;
  time: string;

  decider: {
    type: "human" | "agent" | "system" | "policy_engine" | string;
    id: string;
    role?: string;
  };

  subject: {
    type: "AgentCommand" | "AgentEvent" | "AgentPolicy" | "AgentContract" | string;
    id: string;
  };

  inputs?: {
    commands?: string[];
    events?: string[];
    policies?: string[];
    context_refs?: string[];
  };

  options_considered?: Array<{
    option: string;
    status: "selected" | "not_selected" | "rejected" | string;
    reason?: string;
  }>;

  policy_basis?: {
    engine?: "opa" | "openfga" | "authzen" | string;
    rules?: string[];
  };

  reasoning_summary: string;

  outcome: {
    status: string;
    next_state?: string;
  };

  evidence?: {
    items?: Array<{
      type: string;
      value?: string;
      uri?: string;
      hash?: string;
    }>;
  };

  confidence?: {
    score?: number;
    basis?: string;
  };

  approval?: {
    required?: boolean;
    status?: "approved" | "rejected" | "not_required" | "pending" | string;
  };

  trace?: {
    trace_id: string;
    span_id?: string;
  };
};
```

## Runtime Position

```txt
Agent Command
        ↓
Policy Check
        ↓
Agent Decision
        ↓
Tool Execution / Escalation / Rejection
        ↓
Agent Event
        ↓
Evidence Capture
        ↓
Audit Log
        ↓
Reconciliation Loop
```

## Final Definition

**Agent Decision is the audit-ready record of why a governed action was approved, rejected, escalated, or reconciled.**

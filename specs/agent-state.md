# Agent State

**Agent State** is the current, observable, policy-governed condition of an agent, command, contract, tool, workflow, artifact, or environment.

It is not just data. It is a **trusted snapshot of what exists now, under governance, with provenance and reconciliation status**.

```txt
Agent State =
  Subject
+ State Type
+ Current Value
+ Desired Value
+ Status
+ Provenance
+ Evidence
+ Policy Status
+ Drift Status
+ Time
+ Trace
```

## Definition

An **Agent State** object records what currently exists in the operator fabric.

It tells the system:

1. what object or relationship the state belongs to
2. what the current state is
3. what the desired state is, if known
4. whether the state is trusted
5. which evidence supports it
6. which policy governs it
7. whether drift exists
8. when the state was observed
9. what reconciliation action is required, if any

## Canonical Shape

```json
{
  "kind": "AgentState",
  "version": "0.1.0",
  "id": "state_001",
  "time": "2026-06-07T00:00:00Z",
  "subject": {
    "type": "AgentCommand",
    "id": "cmd_001"
  },
  "state_type": "publication_state",
  "current": {
    "status": "published",
    "artifact": "specs/agent-command.md",
    "repository": "github:AGenNext/Agent-As-A-Operator"
  },
  "desired": {
    "status": "published",
    "artifact": "specs/agent-command.md",
    "repository": "github:AGenNext/Agent-As-A-Operator",
    "evidence_required": ["commit_sha"]
  },
  "status": {
    "value": "trusted",
    "lifecycle": "active"
  },
  "provenance": {
    "source": "github.create_file",
    "observed_by": "agent:operator",
    "observed_at": "2026-06-07T00:00:00Z"
  },
  "evidence": {
    "items": [
      {
        "type": "commit_sha",
        "value": "1038dc1365293e22b565bda75268b4e81f9ded00"
      }
    ]
  },
  "policy_status": {
    "effect": "allow",
    "policies": ["policy_001"]
  },
  "drift": {
    "detected": false,
    "type": null,
    "severity": "none"
  },
  "reconciliation": {
    "required": false,
    "last_reconciliation": "rec_001"
  },
  "trace": {
    "trace_id": "trace_001",
    "span_id": "span_state_001"
  }
}
```

## Natural-Language Form

```txt
For <subject>,
record current state <current>,
compare it with desired state <desired>,
attach <evidence and provenance>,
evaluate <policy status>,
mark <drift and reconciliation status>,
and timestamp the observation.
```

Example:

```txt
For Agent Command cmd_001,
record that specs/agent-command.md is published,
compare it with the desired published state,
attach commit evidence and GitHub provenance,
mark policy as allowed and drift as none,
and timestamp the observation.
```

## Agent State vs Data

| Data | Agent State |
|---|---|
| Raw value | Governed condition |
| May lack time | Time-bound observation |
| May lack provenance | Source and observer recorded |
| May not be trusted | Trust and policy status recorded |
| May not express desired state | Can compare current and desired state |
| Passive | Drives reconciliation |

## State Status

```txt
draft       = state is proposed but not active
active      = state is currently valid
trusted     = state has supporting evidence and policy approval
untrusted   = state lacks sufficient evidence or policy approval
drifting    = actual state differs from desired state
reconciling = convergence action is in progress
suspended   = state is held due to policy, contract, or risk
archived    = state is historical and no longer active
```

## Core Rule

```txt
State is not what the agent says.
State is what the system can observe, prove, govern, and reconcile.
```

## Minimal TypeScript Schema

```ts
type AgentState = {
  kind: "AgentState";
  version: string;
  id: string;
  time: string;

  subject: {
    type: string;
    id: string;
  };

  state_type: string;

  current: Record<string, unknown>;
  desired?: Record<string, unknown>;

  status: {
    value: "draft" | "active" | "trusted" | "untrusted" | "drifting" | "reconciling" | "suspended" | "archived" | string;
    lifecycle?: string;
  };

  provenance?: {
    source?: string;
    observed_by?: string;
    observed_at?: string;
  };

  evidence?: {
    items?: Array<{
      type: string;
      value?: string;
      uri?: string;
      hash?: string;
    }>;
  };

  policy_status?: {
    effect?: "allow" | "deny" | "hold" | "escalate" | string;
    policies?: string[];
  };

  drift?: {
    detected: boolean;
    type?: string | null;
    severity?: "none" | "low" | "medium" | "high" | "critical" | string;
  };

  reconciliation?: {
    required?: boolean;
    last_reconciliation?: string;
  };

  trace?: {
    trace_id: string;
    span_id?: string;
  };
};
```

## Runtime Position

```txt
Observe System
        ↓
Agent State
        ↓
Compare Desired vs Current
        ↓
Detect Drift
        ↓
Agent Reconciliation
        ↓
Agent Decision
        ↓
Agent Event
        ↓
Updated Trusted State
```

## Final Definition

**Agent State is the governed, evidence-backed representation of what currently exists and whether it matches what should exist.**

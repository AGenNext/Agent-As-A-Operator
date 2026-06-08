# Agent Command

**Agent Command** is the smallest governed instruction an agent can accept, validate, execute, observe, and reconcile.

It is not just a prompt. It is a **contracted unit of action**.

```txt
Agent Command =
  Intent
+ Actor
+ Target
+ Context
+ Constraints
+ Tools
+ Policy
+ Expected State
+ Evidence
+ Reconciliation Rule
```

## Definition

An **Agent Command** is a structured instruction issued by a human, system, or another agent that tells an agent:

1. what outcome is required
2. who is allowed to request it
3. what state or object it applies to
4. what tools may be used
5. what rules must be obeyed
6. what evidence must be produced
7. how success, failure, and drift are reconciled

## Canonical Shape

```json
{
  "kind": "AgentCommand",
  "version": "0.1.0",
  "id": "cmd_001",
  "intent": "publish_report",
  "actor": {
    "type": "human",
    "id": "user:chinmay"
  },
  "agent": {
    "id": "agent:publisher",
    "role": "publishing_operator"
  },
  "target": {
    "type": "repository",
    "id": "github:AGenNext/Agent-As-A-Operator"
  },
  "context": {
    "inputs": ["report.md", "schema.json"],
    "source": "chat",
    "trace_id": "trace_001"
  },
  "constraints": {
    "must_obey": [
      "do_not_delete_existing_work",
      "preserve_provenance",
      "use_open_standards"
    ],
    "requires_approval": true
  },
  "tools": {
    "allowed": ["github.create_file", "github.create_pull_request"],
    "denied": ["github.delete_file"]
  },
  "policy": {
    "authz": "opa",
    "identity": "did",
    "audit": true
  },
  "expected_state": {
    "artifact": "published_report",
    "status": "reviewable_pr"
  },
  "evidence": {
    "required": ["commit_sha", "pull_request_url", "validation_log"]
  },
  "reconciliation": {
    "on_success": "record_decision",
    "on_failure": "rollback_or_open_issue",
    "on_drift": "raise_conformance_event"
  }
}
```

## Natural-Language Form

```txt
As <actor>,
ask <agent>
to perform <intent>
on <target>
using <allowed tools>
under <constraints and policy>
until <expected state>
with <evidence>.
```

Example:

```txt
As the founder,
ask the Publishing Agent
to publish the Agent Command specification
to the AGenNext repository
using GitHub file and PR tools
without overwriting existing work
until a reviewable pull request exists
with commit SHA, PR URL, and validation log.
```

## Agent Command vs Prompt

| Prompt | Agent Command |
|---|---|
| Asks for output | Requires state change or decision |
| Free-form | Structured |
| May be ambiguous | Must be bounded |
| Usually no audit | Always traceable |
| May ignore tools/policy | Tool and policy scoped |
| Ends with response | Ends with reconciled state |

## Core Rule

```txt
A prompt asks.
A command binds.
An agent command binds intent to governed execution.
```

## Minimal TypeScript Schema

```ts
type AgentCommand = {
  kind: "AgentCommand";
  version: string;
  id: string;

  intent: string;

  actor: {
    type: "human" | "agent" | "system";
    id: string;
  };

  agent: {
    id: string;
    role: string;
  };

  target: {
    type: string;
    id: string;
  };

  context?: Record<string, unknown>;

  constraints?: {
    must_obey?: string[];
    requires_approval?: boolean;
  };

  tools?: {
    allowed?: string[];
    denied?: string[];
  };

  policy?: {
    authz?: "opa" | "openfga" | "authzen" | string;
    identity?: "did" | "oidc" | string;
    audit?: boolean;
  };

  expected_state: Record<string, unknown>;

  evidence?: {
    required?: string[];
  };

  reconciliation?: {
    on_success?: string;
    on_failure?: string;
    on_drift?: string;
  };
};
```

## Runtime Position

```txt
Human / System / Agent
        ↓
Natural Language Intent
        ↓
Agent Command
        ↓
Policy Check
        ↓
Tool Execution
        ↓
Evidence Capture
        ↓
State Reconciliation
        ↓
Decision / Audit Log
```

## Final Definition

**Agent Command is the governed, executable contract that turns intent into reconciled state.**

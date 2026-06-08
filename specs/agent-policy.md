# Agent Policy

**Agent Policy** is the executable governance rule that determines whether an agent action is allowed, denied, escalated, constrained, or reconciled.

It is not just a guideline. It is a **machine-enforceable rule over identity, authority, context, tools, evidence, and state**.

```txt
Agent Policy =
  Policy Type
+ Scope
+ Subject
+ Conditions
+ Permissions
+ Prohibitions
+ Obligations
+ Evidence Requirements
+ Decision Effect
+ Enforcement Point
+ Reconciliation Action
```

## Definition

An **Agent Policy** applies contract authority to runtime behavior.

It tells the operator fabric:

1. which subjects the rule applies to
2. what actions are allowed
3. what actions are denied
4. which conditions must be true
5. what evidence must exist
6. when human approval is required
7. where the rule is enforced
8. what decision effect must be emitted
9. what happens when policy is violated or drift is detected

## Canonical Shape

```json
{
  "kind": "AgentPolicy",
  "version": "0.1.0",
  "id": "policy_001",
  "name": "Documentation Publish Policy",
  "type": "authorization",
  "scope": {
    "contracts": ["contract_001"],
    "agents": ["agent:publisher", "agent:operator"],
    "targets": ["github:AGenNext/Agent-As-A-Operator"],
    "domains": ["documentation", "specification_management"]
  },
  "subject": {
    "type": "AgentCommand",
    "actions": ["create_file", "update_file", "open_pull_request"]
  },
  "conditions": {
    "all_of": [
      "actor_is_authorized",
      "target_is_in_contract_scope",
      "tool_is_allowed",
      "no_secret_exposure_detected",
      "destructive_change_is_not_requested"
    ]
  },
  "permissions": {
    "allow": [
      "github.create_file",
      "github.update_file",
      "github.create_pull_request"
    ]
  },
  "prohibitions": {
    "deny": [
      "github.delete_file",
      "github.merge_pull_request",
      "publish_private_credentials",
      "bypass_evidence_capture"
    ]
  },
  "obligations": [
    "record_agent_decision",
    "emit_agent_event",
    "capture_commit_sha",
    "preserve_existing_work"
  ],
  "evidence_requirements": [
    {
      "type": "commit_sha",
      "required_for": "publish_success"
    },
    {
      "type": "validation_summary",
      "required_for": "decision_approval"
    },
    {
      "type": "file_path",
      "required_for": "audit_record"
    }
  ],
  "decision_effect": {
    "on_pass": "allow",
    "on_fail": "deny",
    "on_uncertain": "escalate",
    "on_missing_evidence": "hold"
  },
  "enforcement": {
    "point": "before_tool_execution",
    "engine": "opa",
    "relationship_engine": "openfga",
    "external_authorization": "authzen"
  },
  "reconciliation": {
    "on_violation": "suspend_command_and_raise_decision_event",
    "on_drift": "restore_last_policy_compliant_state",
    "on_missing_evidence": "request_evidence_or_rollback"
  }
}
```

## Natural-Language Form

```txt
For <scope>,
when <subject> requests <action>,
allow it only if <conditions> are true,
deny <prohibitions>,
require <obligations and evidence>,
enforce at <enforcement point>,
and reconcile <violations or drift>.
```

Example:

```txt
For documentation publishing under contract_001,
when an Agent Command requests GitHub file creation,
allow it only if the actor, target, and tool are authorized,
deny destructive actions and secret exposure,
require commit evidence and an Agent Decision,
enforce before tool execution,
and suspend the command on violation.
```

## Agent Policy vs Rule

| Rule | Agent Policy |
|---|---|
| May be informal | Machine-enforceable |
| Usually local | Bound to contract, identity, tools, and state |
| Says what should happen | Determines what is allowed to happen |
| May not require evidence | Requires evidence for governed execution |
| May be advisory | Produces allow, deny, hold, or escalate effects |
| Static | Can drive reconciliation when drift occurs |

## Core Rule

```txt
A contract grants authority.
A policy enforces authority.
A decision records how authority was applied.
```

## Minimal TypeScript Schema

```ts
type AgentPolicy = {
  kind: "AgentPolicy";
  version: string;
  id: string;
  name: string;
  type: "authorization" | "approval" | "safety" | "evidence" | "reconciliation" | string;

  scope: {
    contracts?: string[];
    agents?: string[];
    targets?: string[];
    domains?: string[];
  };

  subject: {
    type: string;
    actions?: string[];
  };

  conditions?: {
    all_of?: string[];
    any_of?: string[];
    none_of?: string[];
  };

  permissions?: {
    allow?: string[];
  };

  prohibitions?: {
    deny?: string[];
  };

  obligations?: string[];

  evidence_requirements?: Array<{
    type: string;
    required_for?: string;
  }>;

  decision_effect: {
    on_pass: "allow" | "hold" | "escalate" | string;
    on_fail: "deny" | "hold" | "escalate" | string;
    on_uncertain?: "hold" | "escalate" | string;
    on_missing_evidence?: "hold" | "deny" | "escalate" | string;
  };

  enforcement?: {
    point?: "before_tool_execution" | "after_tool_execution" | "continuous" | string;
    engine?: "opa" | string;
    relationship_engine?: "openfga" | string;
    external_authorization?: "authzen" | string;
  };

  reconciliation?: {
    on_violation?: string;
    on_drift?: string;
    on_missing_evidence?: string;
  };
};
```

## Runtime Position

```txt
Agent Contract
        ↓
Agent Policy
        ↓
Agent Command
        ↓
Policy Evaluation
        ↓
Agent Decision
        ↓
Tool Execution / Hold / Deny / Escalate
        ↓
Agent Event
        ↓
Agent Evidence
        ↓
Reconciliation
```

## Final Definition

**Agent Policy is the executable governance layer that converts contract authority into runtime allow, deny, hold, escalate, or reconcile decisions.**

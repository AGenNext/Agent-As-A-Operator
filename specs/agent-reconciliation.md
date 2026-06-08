# Agent Reconciliation

**Agent Reconciliation** is the governed convergence process that compares desired state with actual state and takes policy-compliant action to remove drift.

It is not just retry logic. It is a **contract-aware control loop for restoring trusted state**.

```txt
Agent Reconciliation =
  Desired State
+ Actual State
+ Drift Detection
+ Policy Evaluation
+ Decision
+ Repair Plan
+ Execution
+ Evidence
+ Event Emission
+ Final State
```

## Definition

An **Agent Reconciliation** object records how the system detects, evaluates, and resolves drift.

It tells the operator fabric:

1. what state was expected
2. what state was observed
3. what drift was detected
4. whether the drift is allowed, denied, or tolerated
5. which policy and contract govern repair
6. what decision was made
7. what repair action was selected
8. what evidence proves convergence
9. what final state was reached
10. whether further escalation is required

## Canonical Shape

```json
{
  "kind": "AgentReconciliation",
  "version": "0.1.0",
  "id": "rec_001",
  "time": "2026-06-07T00:00:00Z",
  "subject": {
    "type": "AgentCommand",
    "id": "cmd_001"
  },
  "desired_state": {
    "status": "published",
    "artifact": "specs/agent-command.md",
    "repository": "github:AGenNext/Agent-As-A-Operator",
    "evidence_required": ["commit_sha"]
  },
  "actual_state": {
    "status": "published",
    "artifact": "specs/agent-command.md",
    "repository": "github:AGenNext/Agent-As-A-Operator",
    "evidence": ["1038dc1365293e22b565bda75268b4e81f9ded00"]
  },
  "drift": {
    "detected": false,
    "type": null,
    "severity": "none",
    "description": "Actual state matches desired state and required evidence is present."
  },
  "policy_evaluation": {
    "policies": ["policy_001"],
    "effect": "allow",
    "reason": "Published artifact and commit evidence satisfy policy."
  },
  "decision": {
    "type": "AgentDecision",
    "id": "dec_001",
    "outcome": "state_converged"
  },
  "repair_plan": {
    "required": false,
    "actions": []
  },
  "execution": {
    "status": "not_required",
    "tools_used": []
  },
  "evidence": {
    "items": [
      {
        "type": "commit_sha",
        "value": "1038dc1365293e22b565bda75268b4e81f9ded00"
      }
    ]
  },
  "events": [
    {
      "type": "agent.reconciliation.converged",
      "id": "evt_rec_001"
    }
  ],
  "final_state": {
    "status": "converged",
    "trusted": true
  },
  "escalation": {
    "required": false,
    "reason": null
  },
  "trace": {
    "trace_id": "trace_001",
    "span_id": "span_reconciliation_001"
  }
}
```

## Natural-Language Form

```txt
For <subject>,
compare <desired state> with <actual state>,
detect <drift>,
evaluate <policy>,
decide <repair or acceptance>,
execute <repair plan if required>,
record <evidence and event>,
and declare <final state>.
```

Example:

```txt
For Agent Command cmd_001,
compare the desired published specification with the repository state,
detect no drift,
evaluate publishing policy as allowed,
decide state_converged,
record commit evidence and a reconciliation event,
and declare trusted converged state.
```

## Agent Reconciliation vs Retry

| Retry | Agent Reconciliation |
|---|---|
| Repeats an action | Compares desired and actual state |
| Usually local | Bound to contract, policy, evidence, and state |
| Assumes the same action is still valid | Re-evaluates authority before action |
| May hide failure | Emits events and evidence |
| Focused on execution | Focused on convergence |
| Ends when action succeeds | Ends when state is trusted or escalated |

## Drift Types

```txt
missing_state        = desired object or state does not exist
unexpected_state     = actual state exists but does not match desired state
unauthorized_state   = actual state violates contract or policy
missing_evidence     = state may exist but proof is absent
stale_state          = state exists but is no longer current
conflicting_state    = multiple incompatible states exist
external_drift       = outside system changed state without governed command
policy_drift         = state was valid before but policy changed
contract_drift       = state was valid before but contract changed
```

## Reconciliation Outcomes

```txt
converged      = actual state matches desired state with required evidence
repairing      = repair plan is executing
held           = system is waiting for evidence, approval, or dependency
denied         = repair is not permitted by policy
escalated      = human or higher authority is required
rolled_back    = state was restored to last trusted state
accepted_drift = drift is tolerated under policy
failed         = convergence could not be achieved
```

## Core Rule

```txt
State drifts.
Policy judges.
Reconciliation converges.
```

## Minimal TypeScript Schema

```ts
type AgentReconciliation = {
  kind: "AgentReconciliation";
  version: string;
  id: string;
  time: string;

  subject: {
    type: "AgentCommand" | "AgentEvent" | "AgentContract" | "AgentPolicy" | "AgentState" | string;
    id: string;
  };

  desired_state: Record<string, unknown>;
  actual_state: Record<string, unknown>;

  drift: {
    detected: boolean;
    type?: string | null;
    severity?: "none" | "low" | "medium" | "high" | "critical" | string;
    description?: string;
  };

  policy_evaluation?: {
    policies?: string[];
    effect: "allow" | "deny" | "hold" | "escalate" | string;
    reason?: string;
  };

  decision?: {
    type?: "AgentDecision" | string;
    id?: string;
    outcome?: string;
  };

  repair_plan?: {
    required: boolean;
    actions?: Array<{
      type: string;
      tool?: string;
      target?: string;
      requires_approval?: boolean;
    }>;
  };

  execution?: {
    status: "not_required" | "pending" | "running" | "completed" | "failed" | string;
    tools_used?: string[];
  };

  evidence?: {
    items?: Array<{
      type: string;
      value?: string;
      uri?: string;
      hash?: string;
    }>;
  };

  events?: Array<{
    type: string;
    id: string;
  }>;

  final_state: {
    status: "converged" | "repairing" | "held" | "denied" | "escalated" | "rolled_back" | "accepted_drift" | "failed" | string;
    trusted?: boolean;
  };

  escalation?: {
    required?: boolean;
    reason?: string | null;
  };

  trace?: {
    trace_id: string;
    span_id?: string;
  };
};
```

## Runtime Position

```txt
Desired State
        ↓
Observe Actual State
        ↓
Detect Drift
        ↓
Evaluate Contract + Policy
        ↓
Agent Decision
        ↓
Repair / Hold / Deny / Escalate
        ↓
Agent Event
        ↓
Agent Evidence
        ↓
Trusted State
```

## Final Definition

**Agent Reconciliation is the governed control loop that turns drift into a policy-compliant path back to trusted state.**

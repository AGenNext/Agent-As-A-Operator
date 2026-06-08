# Agent Contract

**Agent Contract** is the governed agreement that defines what an agent is allowed to do, for whom, under which constraints, with what evidence, and under what accountability model.

It is not just terms or configuration. It is an **operational agreement between identity, intent, policy, tools, and state**.

```txt
Agent Contract =
  Parties
+ Scope
+ Authority
+ Obligations
+ Permissions
+ Constraints
+ Tools
+ Evidence Requirements
+ Policy Bindings
+ Term
+ Breach Conditions
+ Reconciliation Rules
```

## Definition

An **Agent Contract** defines the durable agreement that governs an agent relationship.

It tells the operator fabric:

1. who the contract is between
2. what the agent is authorized to do
3. what actions are forbidden
4. what obligations must always hold
5. which tools and systems may be accessed
6. what evidence must be produced
7. which policies bind execution
8. how breach, drift, suspension, and termination are handled
9. how the system reconciles back to an agreed state

## Canonical Shape

```json
{
  "kind": "AgentContract",
  "version": "0.1.0",
  "id": "contract_001",
  "name": "Publishing Operator Contract",
  "parties": [
    {
      "type": "human",
      "id": "user:chinmay",
      "role": "principal"
    },
    {
      "type": "agent",
      "id": "agent:publisher",
      "role": "operator"
    },
    {
      "type": "organization",
      "id": "org:AGenNext",
      "role": "governance_authority"
    }
  ],
  "scope": {
    "domains": ["documentation", "repository_publishing", "specification_management"],
    "targets": ["github:AGenNext/Agent-As-A-Operator"],
    "excluded": ["destructive_repository_operations", "secret_rotation", "production_deployment"]
  },
  "authority": {
    "grants": [
      "create_documentation_files",
      "update_specifications",
      "open_pull_requests",
      "record_evidence"
    ],
    "requires_approval_for": [
      "delete_file",
      "merge_pull_request",
      "change_repository_settings"
    ]
  },
  "obligations": [
    "preserve_existing_work",
    "maintain_audit_trail",
    "produce_commit_evidence",
    "respect_repository_scope",
    "record_decision_basis"
  ],
  "permissions": {
    "tools_allowed": [
      "github.create_file",
      "github.update_file",
      "github.create_pull_request",
      "github.fetch_file"
    ],
    "tools_denied": [
      "github.delete_file",
      "github.merge_pull_request"
    ]
  },
  "constraints": {
    "must_obey": [
      "no_overwrite_without_fetch",
      "no_secret_exposure",
      "no_unapproved_destructive_change"
    ],
    "must_not": [
      "publish_private_credentials",
      "claim_unverified_execution",
      "bypass_policy"
    ]
  },
  "evidence_requirements": [
    {
      "type": "commit_sha",
      "required": true
    },
    {
      "type": "file_path",
      "required": true
    },
    {
      "type": "validation_summary",
      "required": true
    }
  ],
  "policy_bindings": {
    "authorization": "opa",
    "relationship_access": "openfga",
    "external_authorization": "authzen",
    "identity": "did-or-oidc"
  },
  "term": {
    "status": "active",
    "effective_from": "2026-06-07T00:00:00Z",
    "expires_at": null
  },
  "breach_conditions": [
    "tool_scope_violation",
    "missing_required_evidence",
    "unauthorized_state_change",
    "policy_denial_ignored"
  ],
  "reconciliation": {
    "on_breach": "suspend_agent_and_raise_decision_event",
    "on_drift": "restore_to_last_approved_state",
    "on_completion": "record_contract_performance"
  }
}
```

## Natural-Language Form

```txt
Between <principal> and <agent>,
under <governance authority>,
allow <scope and authority>,
forbid <excluded actions>,
require <obligations and evidence>,
bind <policies>,
and reconcile <breach or drift> back to <agreed state>.
```

Example:

```txt
Between the founder and the Publishing Agent,
under AGenNext governance,
allow documentation publishing to the operator repository,
forbid destructive repository operations,
require commit evidence and decision records,
bind OPA, OpenFGA, AuthZEN, and identity policy,
and reconcile any breach by suspension and review.
```

## Agent Contract vs Configuration

| Configuration | Agent Contract |
|---|---|
| Sets behavior | Establishes authority |
| Often local | Applies across identity, tools, policy, and state |
| Can be changed silently | Requires governed lifecycle |
| May not define accountability | Defines parties and obligations |
| Describes settings | Describes rights, duties, and remedies |
| Passive | Enforceable by policy and reconciliation |

## Core Rule

```txt
A command asks for action.
A policy permits or denies action.
A contract grants the authority from which action becomes legitimate.
```

## Minimal TypeScript Schema

```ts
type AgentContract = {
  kind: "AgentContract";
  version: string;
  id: string;
  name: string;

  parties: Array<{
    type: "human" | "agent" | "organization" | "system" | string;
    id: string;
    role: string;
  }>;

  scope: {
    domains?: string[];
    targets?: string[];
    excluded?: string[];
  };

  authority: {
    grants: string[];
    requires_approval_for?: string[];
  };

  obligations?: string[];

  permissions?: {
    tools_allowed?: string[];
    tools_denied?: string[];
  };

  constraints?: {
    must_obey?: string[];
    must_not?: string[];
  };

  evidence_requirements?: Array<{
    type: string;
    required: boolean;
  }>;

  policy_bindings?: {
    authorization?: "opa" | string;
    relationship_access?: "openfga" | string;
    external_authorization?: "authzen" | string;
    identity?: "did" | "oidc" | string;
  };

  term: {
    status: "draft" | "active" | "suspended" | "terminated" | "expired" | string;
    effective_from?: string;
    expires_at?: string | null;
  };

  breach_conditions?: string[];

  reconciliation?: {
    on_breach?: string;
    on_drift?: string;
    on_completion?: string;
  };
};
```

## Runtime Position

```txt
Agent Contract
        ↓
Authority Grant
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
Reconciliation / Breach Handling
```

## Final Definition

**Agent Contract is the enforceable agreement that gives an agent legitimate authority to act within a governed operational boundary.**

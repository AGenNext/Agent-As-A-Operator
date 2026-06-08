# Agent Evidence

**Agent Evidence** is the verifiable proof object that supports an agent command, decision, event, policy evaluation, contract obligation, or reconciled state.

It is not just an attachment. It is a **governed proof of what was observed, produced, verified, or changed**.

```txt
Agent Evidence =
  Evidence Type
+ Subject
+ Source
+ Claim
+ Artifact
+ Verification Method
+ Hash / Signature
+ Time
+ Trace
+ Retention Rule
+ Trust Status
```

## Definition

An **Agent Evidence** object proves that a governed action, state transition, or decision has support.

It tells the operator fabric:

1. what claim the evidence supports
2. which command, event, decision, policy, or contract it belongs to
3. where the evidence came from
4. what artifact or observation was captured
5. how the artifact can be verified
6. whether the evidence is complete, missing, disputed, or trusted
7. how long it must be retained
8. how it participates in audit and reconciliation

## Canonical Shape

```json
{
  "kind": "AgentEvidence",
  "version": "0.1.0",
  "id": "evd_001",
  "type": "commit_sha",
  "time": "2026-06-07T00:00:00Z",
  "subject": {
    "type": "AgentEvent",
    "id": "evt_001"
  },
  "supports": [
    {
      "type": "AgentCommand",
      "id": "cmd_001",
      "claim": "documentation_specification_was_published"
    },
    {
      "type": "AgentDecision",
      "id": "dec_001",
      "claim": "publish_action_was_allowed_by_policy"
    }
  ],
  "source": {
    "type": "tool",
    "id": "github.create_file",
    "system": "github"
  },
  "claim": {
    "statement": "File specs/agent-command.md was created in AGenNext/Agent-As-A-Operator.",
    "status": "verified"
  },
  "artifact": {
    "type": "repository_commit",
    "uri": "github://AGenNext/Agent-As-A-Operator/commit/1038dc1365293e22b565bda75268b4e81f9ded00",
    "value": "1038dc1365293e22b565bda75268b4e81f9ded00"
  },
  "verification": {
    "method": "repository_lookup",
    "verifier": "agent:operator",
    "status": "verified",
    "checked_at": "2026-06-07T00:00:00Z"
  },
  "integrity": {
    "hash": null,
    "signature": null,
    "signed_by": null
  },
  "trace": {
    "trace_id": "trace_001",
    "span_id": "span_evidence_001"
  },
  "retention": {
    "classification": "audit_record",
    "retain_for": "project_lifetime",
    "delete_allowed": false
  },
  "trust": {
    "status": "trusted",
    "score": 1.0,
    "basis": "source tool returned commit sha after successful repository write"
  }
}
```

## Natural-Language Form

```txt
For <subject>,
record evidence that <claim>
from <source>
as <artifact>
verified by <method>
with <integrity proof>
under <trace and retention rule>
and mark trust as <status>.
```

Example:

```txt
For Agent Event evt_001,
record evidence that the specification was published
from github.create_file
as a repository commit SHA
verified by repository lookup
under trace_001 and audit retention
and mark trust as trusted.
```

## Agent Evidence vs Artifact

| Artifact | Agent Evidence |
|---|---|
| A produced file, value, or output | A proof object supporting a claim |
| May exist alone | Bound to command, decision, event, policy, or contract |
| May not be verified | Has verification status |
| May not be retained | Has retention rule |
| May not prove anything | Explicitly supports a claim |
| Passive | Can allow, block, or trigger reconciliation |

## Evidence Status

```txt
missing     = required evidence does not exist
captured    = evidence exists but has not been verified
verified    = evidence has been checked against its source
trusted     = evidence is verified and accepted for audit
rejected    = evidence failed verification
disputed    = evidence is contested and requires review
expired     = evidence is no longer valid for its claim
```

## Core Rule

```txt
A decision explains why.
An event records what changed.
Evidence proves the claim can be trusted.
```

## Minimal TypeScript Schema

```ts
type AgentEvidence = {
  kind: "AgentEvidence";
  version: string;
  id: string;
  type: string;
  time: string;

  subject: {
    type: "AgentCommand" | "AgentDecision" | "AgentEvent" | "AgentPolicy" | "AgentContract" | string;
    id: string;
  };

  supports?: Array<{
    type: string;
    id: string;
    claim: string;
  }>;

  source: {
    type: "human" | "agent" | "system" | "tool" | "repository" | string;
    id: string;
    system?: string;
  };

  claim: {
    statement: string;
    status: "missing" | "captured" | "verified" | "trusted" | "rejected" | "disputed" | "expired" | string;
  };

  artifact?: {
    type: string;
    uri?: string;
    value?: string;
    media_type?: string;
  };

  verification?: {
    method?: string;
    verifier?: string;
    status?: "unverified" | "verified" | "failed" | string;
    checked_at?: string;
  };

  integrity?: {
    hash?: string | null;
    signature?: string | null;
    signed_by?: string | null;
  };

  trace?: {
    trace_id: string;
    span_id?: string;
  };

  retention?: {
    classification?: string;
    retain_for?: string;
    delete_allowed?: boolean;
  };

  trust?: {
    status?: "untrusted" | "trusted" | "disputed" | string;
    score?: number;
    basis?: string;
  };
};
```

## Runtime Position

```txt
Agent Command
        ↓
Agent Decision
        ↓
Agent Event
        ↓
Agent Evidence
        ↓
Verification
        ↓
Audit Log
        ↓
Reconciliation Decision
        ↓
Trusted State
```

## Final Definition

**Agent Evidence is the governed proof object that turns agent claims, events, and decisions into verifiable operational facts.**

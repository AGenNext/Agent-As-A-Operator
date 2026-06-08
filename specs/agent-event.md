# Agent Event

**Agent Event** is the smallest observable state transition emitted by an agent, tool, policy engine, or external system.

It is not just a log line. It is a **verifiable record of change**.

```txt
Agent Event =
  Event Type
+ Source
+ Subject
+ Time
+ Previous State
+ Current State
+ Cause
+ Evidence
+ Trace
+ Reconciliation Signal
```

## Definition

An **Agent Event** records that something meaningful happened in the agent system.

It tells the fabric:

1. what changed
2. who or what caused the change
3. which command, decision, or policy produced it
4. what state existed before
5. what state exists now
6. what evidence supports the transition
7. whether reconciliation is required

## Canonical Shape

```json
{
  "kind": "AgentEvent",
  "version": "0.1.0",
  "id": "evt_001",
  "type": "agent.command.accepted",
  "time": "2026-06-07T00:00:00Z",
  "source": {
    "type": "agent",
    "id": "agent:operator"
  },
  "subject": {
    "type": "command",
    "id": "cmd_001"
  },
  "cause": {
    "type": "AgentCommand",
    "id": "cmd_001"
  },
  "state": {
    "previous": "pending_validation",
    "current": "accepted"
  },
  "evidence": {
    "required": true,
    "items": [
      {
        "type": "validation_log",
        "uri": "trace://trace_001/validation"
      }
    ]
  },
  "trace": {
    "trace_id": "trace_001",
    "span_id": "span_001"
  },
  "reconciliation": {
    "required": false,
    "signal": "state_converged"
  }
}
```

## Natural-Language Form

```txt
When <source>
changes <subject>
from <previous state>
to <current state>
because of <cause>
record <evidence>
under <trace>
and emit <reconciliation signal>.
```

Example:

```txt
When the Operator Agent
accepts Agent Command cmd_001
from pending_validation
to accepted
because policy validation passed
record the validation log
under trace_001
and emit state_converged.
```

## Agent Event vs Log

| Log | Agent Event |
|---|---|
| Describes something | Records a governed state transition |
| Often text-only | Structured |
| May be incomplete | Requires subject, cause, and time |
| Debug-oriented | Reconciliation-oriented |
| Usually local | Traceable across the fabric |
| Passive | Can trigger policy, workflow, or reconciliation |

## Core Rule

```txt
A log remembers.
An event moves.
An agent event moves the system from one governed state to another.
```

## Minimal TypeScript Schema

```ts
type AgentEvent = {
  kind: "AgentEvent";
  version: string;
  id: string;
  type: string;
  time: string;

  source: {
    type: "human" | "agent" | "system" | "tool" | string;
    id: string;
  };

  subject: {
    type: string;
    id: string;
  };

  cause?: {
    type: "AgentCommand" | "AgentDecision" | "AgentPolicy" | string;
    id: string;
  };

  state?: {
    previous?: string | Record<string, unknown>;
    current?: string | Record<string, unknown>;
  };

  evidence?: {
    required?: boolean;
    items?: Array<{
      type: string;
      uri?: string;
      hash?: string;
    }>;
  };

  trace?: {
    trace_id: string;
    span_id?: string;
  };

  reconciliation?: {
    required?: boolean;
    signal?: string;
  };
};
```

## Runtime Position

```txt
Agent Command
        ↓
Policy / Tool / Agent Action
        ↓
Agent Event
        ↓
Trace Store
        ↓
Decision / Audit Log
        ↓
Reconciliation Loop
        ↓
Desired State Update
```

## Final Definition

**Agent Event is the observable, evidence-backed state transition that lets the system know what changed and whether reconciliation is required.**

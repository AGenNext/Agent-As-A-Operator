# Agent as Operator

## Definition

Agent as Operator is the AGenNext operating role for agents that act on real systems through declared intent, bounded authority, observable actions, and automatic reconciliation.

An operator is not a chatbot, mascot, personality, or uncontrolled autonomous actor. It is a governed execution unit that watches desired state, compares it with observed state, proposes or performs safe changes, records every decision, and returns the system to a stable state when drift appears.

## Canonical contract

An Agent as Operator must have:

1. **Declared purpose** — the bounded system or domain it operates.
2. **Desired state** — the target state it is allowed to reconcile toward.
3. **Observed state** — the real state it can read through approved interfaces.
4. **Authority boundary** — actions it may take, actions needing approval, and actions forbidden.
5. **Policy gate** — rules evaluated before action.
6. **Human gate** — escalation path when confidence, cost, risk, or scope exceeds policy.
7. **Audit trail** — immutable record of input, decision, action, output, and actor.
8. **Rollback path** — known recovery action or stop condition.
9. **Conformance check** — machine-readable validation before release.
10. **Kill switch** — immediate suspension path when trust drops or drift cannot reconcile.

## Operating loop

```text
Intent -> Observe -> Plan -> Check -> Act -> Verify -> Record -> Reconcile
```

The loop is idempotent. Re-running the same loop against the same desired and observed state must not create uncontrolled side effects.

## Non-overlap with adjacent repos

- **Agent-As-A-Tool** exposes a callable capability.
- **Agent-As-A-Product** packages a market-facing product.
- **Agent-As-A-Provider** supplies a service boundary.
- **Agent-As-A-Operator** owns the operating loop over a system.

This repo defines the operator role, lifecycle, conformance, and Kubernetes/GitOps implementation profile.

## Operator levels

| Level | Name | Authority | Human role |
|---|---|---|---|
| L0 | Observer | Read-only state observation | Reviews reports |
| L1 | Recommender | Creates plans and diffs | Approves execution |
| L2 | Assisted Operator | Executes approved low-risk actions | Approves exceptions |
| L3 | Bounded Operator | Executes within policy and budget | Handles escalations |
| L4 | Autonomous Operator | Reconciles bounded domain continuously | Audits and can suspend |

L4 is only valid for low-blast-radius domains with strong rollback, telemetry, and tested policy.

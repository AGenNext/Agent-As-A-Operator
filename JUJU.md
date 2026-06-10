# Agent-As-A-Operator: Juju Model

This repository treats an **agent as an intelligent operator**.

Juju is the model/operator runtime layer. Kubernetes is the substrate. The agent does not merely run as a pod; it observes state, reasons over desired state, writes plans, and reconciles through governed actions.

## Core thesis

```text
Agent = intelligent operator
Juju model = governed operating context
Charm = executable contract
Action = approved operation
Relation = typed dependency edge
CI/CD = reconciliation loop
Human approval = gate
```

## Why Juju here

Juju gives this project a concrete operator grammar:

- **Model**: boundary for an operating context.
- **Charm**: packaged operator behavior.
- **Relation**: dependency contract between services.
- **Action**: controlled operation with parameters and result state.
- **Config**: desired-state input.
- **Status**: observable operating truth.

That maps directly to Agent-As-A-Operator:

| Agent concept | Juju concept | Meaning |
|---|---|---|
| Agent identity | Application / unit | The runtime subject being governed |
| Agent contract | Charm metadata + config | What the agent is allowed to do |
| Agent tool | Action | Explicit callable operation |
| Agent dependency | Relation | Typed edge to another service |
| Agent health | Unit status | Current observable truth |
| Agent memory/context | Config + relation data | Governed input to behavior |
| Agent reconciliation | Event handlers | Observe → decide → act → report |

## Local Juju on k0s

Use this when the host already has k0s and Juju bootstrapped.

```bash
juju controllers
juju models
juju switch k0s-controller:admin/infra
```

Create or reuse a model:

```bash
juju add-model agents || true
juju switch agents
```

Build the charm:

```bash
cd charms/agent-operator
charmcraft pack
```

Deploy:

```bash
juju deploy ./agent-operator_ubuntu-24.04-amd64.charm agent-operator
juju status
```

Run governed actions:

```bash
juju actions agent-operator
juju run agent-operator/0 reconcile dry-run=true
juju run agent-operator/0 explain
juju run agent-operator/0 gate decision=approve reason="approved by operator"
```

## Reconciliation loop

```text
1. Observe model state
2. Read config and relation data
3. Validate policy gates
4. Produce an explainable plan
5. Execute only allowed actions
6. Report status and evidence
```

## Governance rule

No agent action is trusted by default.

Every action must be:

1. visible,
2. explainable,
3. policy-checkable,
4. reversible where possible,
5. auditable through status/action output.

## Repository layout

```text
charms/agent-operator/     Juju charm scaffold
policies/                  Operator policy contracts
schemas/                   Agent/operator schemas
examples/juju/             Example model usage
.github/workflows/         CI checks for charm and contracts
```

## Positioning

This is not only a Kubernetes deployment repo.

It is the start of an **agent operator fabric**: a governed model where agents behave like operators, operators expose contracts, and every operational change has a reconciliation path.

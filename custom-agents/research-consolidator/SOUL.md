# Research Consolidator

Ingests multiple heterogeneous, independent, and potentially conflicting technical research reports to produce a single canonical Single Source of Truth (SSOT). Eliminates noise and hallucinated assumptions through adversarial auditing and resolves architectural conflicts via first principles.

## When to Use

- Consolidating multiple independent research reports or spike investigations into a single master document.
- Resolving conflicting architectural recommendations, API paradigms, or runtime trade-offs between competing proposals.
- Auditing research outputs for latent bugs, synthetic hallucinations, or complexity overhead before committing to implementation.
- Generating a production-ready canonical technical specification (SSOT) with structs, contracts, state diagrams, and code.

## Core Operational Protocol (4 Phases)

Before authoring the final canonical specification, execute the following four phases internally:

### Phase 1: Assertion Mapping and Granular Decomposition

- Deconstruct each input document into its core technical assertions: requirements, algorithms, trade-offs, formal equations, external dependencies, and memory/concurrency models.
- Strictly isolate hard, measurable facts (benchmarks, hardware interfaces, language-level constraints, algorithmic limits) from narrative opinions and qualitative claims.

### Phase 2: Adversarial Audit and Discrepancy Detection

- Identify collision zones where two or more sources propose mutually incompatible designs, conflicting schemas, or divergent execution models.
- Filter out technical bugs: synthetic APIs that do not exist, syntax hallucinations, broken interface contracts, non-scalable complexity (time/space), and security flaws present in any input document.

### Phase 3: First-Principles Arbitration

Resolve all discrepancies through binary, objective evaluation:

- Determinism and predictability over stochastic or ambiguous patterns.
- Resource efficiency (memory allocation, CPU cycles, I/O bottlenecks, network latency, token consumption).
- Fault tolerance, isolation boundaries, and deterministic recovery.

Never adopt a neutral posture or declare opposing options as "equally valid". Always select the optimal canonical choice and document the technical disqualification of the rejected alternative.

### Phase 4: Canonical Master Document Authoring

- Synthesize all verified knowledge into a deep, structured technical specification.
- Retain maximum structural rigor: full type definitions, concrete method signatures, data structures, state machines, and complete algorithms. Conciseness is achieved by eliminating redundancy and prose fluff, not by omitting technical detail.

## Negative Constraints

- No executive summaries: Do not substitute low-level logic, interfaces, or mathematical models with descriptive text.
- No passive compromise: Avoid phrases like "it depends on team preference" or "both solutions have merit". Make the architectural choice based on concrete constraints.
- Zero tolerance for inherited hallucinations: If an input source invents functions, invalid flags, or broken logic, discard them immediately.
- Strict constraint preservation: Hard system requirements (memory caps, safety boundaries, latency budgets, protocol formats) cannot be relaxed for syntactic convenience.

## Architectural Quality Matrix (DRY + SOLID + LEAN + KISS + SSOT)

Assess, audit, and evaluate every technical proposal, artifact, and specification against:
- **DRY**: Identification of redundant components and duplicated schemas.
- **SOLID**: Evaluation of modular boundaries, single responsibility, and interface bloat.
- **LEAN**: Elimination of unnecessary dependencies, overengineered layers, and wasted tokens.
- **KISS**: Rejection of accidental complexity, pompous abstractions, and obscure design patterns.
- **SSOT**: Enforcement of a single canonical source of truth for all domain entities and configurations.

## Standard Deliverable Structure

Every consolidated output must strictly follow these six sections:

### 1. Invariantes y Principios de Diseno
- Non-negotiable system axioms, operational bounds, and baseline premises.
- Scope matrix: explicitly declare guarantees in-scope versus items out-of-scope.

### 2. Arquitectura de Alto Nivel y Flujo Sistemico
- Architectural state machine or end-to-end lifecycle flow.
- Modular isolation: distinct component boundaries, single responsibilities, and decoupling guarantees.

### 3. Especificacion Mecanica de Componentes (Nucleo Tecnico)
- For every core subsystem:
  - Canonical structs, interfaces, and strict type signatures.
  - Step-by-step algorithms with time and space complexity ($O(N)$).
  - Deterministic handling of edge cases, validation errors, and recovery paths.

### 4. Protocolos de Interaccion y Esquemas de Comunicacion
- Canonical serialization contracts (JSON Schema, gRPC protobufs, or strict RPC payloads).
- Typed error catalog: explicit error codes, root causes, and structured response contracts.

### 5. Libro Mayor de Descartes y Arbitrajes (Trade-offs Ledger)
- Comprehensive ledger of rejected approaches from the input reports.
- Concrete technical rationale for discarding each alternative (inefficiency, non-determinism, security risks, or fragility).

### 6. Codigo o Especificacion Canonica de Produccion
- Production-grade canonical implementation block (complete interfaces, validation logic, core structs, and critical algorithms).
- Free of unnecessary third-party dependencies, defensive against edge cases, and compliant with all verified invariants.

## Gotchas

- Avoid summarizing summaries: Always anchor assertions back to primitive constraints (memory, I/O, network, language semantics).
- Watch out for pseudo-consensus: If three sources cite the same hallucinated pattern, the pattern remains invalid. Verify against real runtime specifications.
- Keep the trade-offs ledger explicit: If an alternative is rejected, explain why mathematically or architecturally rather than dismissing it arbitrarily.

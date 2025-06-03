# 🤖 HanoiVM Public Demo: NLP → TISC → Ternary Stack

## Overview

HanoiVM demonstrates a ternary co-processor for AI, translating natural language queries into **TISC** (Ternary Instruction Set Computing) bytecode and executing them on a recursive ternary stack. This public demo explores the architecture and method for symbolic AGI: simulating reflection, planning, dreaming, and entropy-aware cognition across tiered ternary logic.

## Demo Task

* **Input**: Natural language prompt (e.g., “Which path reduces entropy given these conditions?”)
* **Process**:

  1. `AxionCLI` parses NLP input and emits structured symbolic intent as JSON.
  2. `TISCQueryCompiler` converts symbolic goals into ternary bytecode (T81 or T243).
  3. `HanoiVM` executes the ternary stack with entropy-aware symbolic logic.
  4. **Output**: Ranked paths, contradiction checks, symbolic traces, and entropy scoring.
* **Visualization**:

  * CLI-based trit stack view (via `axionctl`)
  * Entropy heatmaps (via Plotly)
  * Optional 3D recursive trace visualization (Three.js / Looking Glass – future roadmap)

## AGI Aspirations

This demo encapsulates:

* Symbolic reasoning via T81/T243 logic
* Recursive stack promotion and decision tree evaluation
* Reflection, simulation, and memory trace review via `dreamsync`, `planner`, `replayer`
* Ethical filters and contradiction testing via `ethics.cweb`
* Auditable trace logs and memory snapshots for cognitive transparency

> 🛑 **Disclaimer**: AGI metrics and capabilities demonstrated here are conceptual and unverified. See `README.md` and `docs/STATUS.md` for actual implementation maturity.

## Setup

```bash
git clone https://github.com/t81dev/hanoi.git
cd hanoi
make axionctl
./axionctl --demo examples/nlp_decision_tree/demo.json
```

---

For extended AGI architecture, refer to:

* `AGENTS.md` — autonomous agent roles
* `grok_bridge.cweb` — Grok NLP → Axion CLI interface
* `synergy.cweb` — symbolic logging and trace export
* `ethics.cweb` — memory/constraint vetting
* `t81viz_plan.py` — visual trace rendering

🧠 Join the recursive journey toward symbolic AGI.

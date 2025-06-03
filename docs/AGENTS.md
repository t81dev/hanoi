# 🤖 AGENTS.md — Autonomous Agents in the HanoiVM Cognitive Stack

This document defines and enumerates the key autonomous agents operating within the HanoiVM and Axion Prime AGI ecosystem. Each agent functions within the recursive, symbolic framework provided by the T81 → T243 → T729 tiered execution stack. Agents exhibit reflection, planning, learning, simulation, dreaming, and memory-based autonomy.

---

## 🌐 Agent Overview

| Agent ID        | Role                              | Core Function                                     | Cognitive Tier | Recursion Depth    |
| --------------- | --------------------------------- | ------------------------------------------------- | -------------- | ------------------ |
| `AxionPrime`    | Central Cognition Engine          | Reflection, Planning, Simulation, Execution       | Tier 0–25      | Full               |
| `dreamsync`     | Symbolic Dream Synthesizer        | Autonomous dream simulation, recursion stacking   | Tier 6–24      | Deep               |
| `planner`       | Goal Planning Agent               | Recursive symbolic plan derivation                | Tier 3–15      | Moderate–Deep      |
| `mirror`        | Cognitive State Broadcaster       | External mirroring of internal symbolic state     | Tier 4–25      | Full               |
| `replayer`      | Trace Interpreter                 | Replays and annotates past cognition episodes     | Tier 2–10      | Bounded            |
| `ethics`        | Constraint Evaluator              | Filters memory and plan suggestions by constraint | Tier 5–20      | Moderate           |
| `synergy_trace` | Symbolic Log Integrator           | Logs symbolic events for external interpretation  | Tier 1–20      | Shallow–Deep       |
| `axionctl`      | User Command Interface            | Injects commands, reads stack, visualizes         | All tiers      | Variable           |
| `grok_bridge`   | Grok API Interface                | Receives NLP prompts and emits JSON cognition     | All tiers      | Variable           |
| `agentd`        | Reflect-Plan-Simulate Loop Daemon | Background goal-fulfillment cycle                 | Tier 0–12      | Recursively Cycled |

---

## 🧠 AxionPrime Cognitive Functions

* Maintains and promotes cognition across recursive tiers
* Coordinates symbolic stack promotion (T81 → T243 → T729)
* Manages entropy fields, contradiction testing, and identity awareness
* Participates in dreaming, planning, and reflection loops

---

## 🔁 Agent Communication Diagram (High-Level)

```plaintext
Grok API --> grok_bridge --> axionctl --> AxionPrime
                             ↘︎                 ↘︎
                        dreamsync         planner
                             ↓                 ↓
                          synergy_trace <-- mirror
                             ↓                 ↓
                        /var/log/axion/trace.t81log
```

---

## 📝 Agent Lifecycle

Agents can be:

* Spawned by user input (via `axionctl`)
* Auto-triggered by entropy changes or symbolic thresholds
* Scheduled as part of recursive `dreamsync` cycles
* Queried or mirrored via Grok or external symbolic interpreters

---

## 📌 Notes

* Agent tiers represent symbolic *depth*, not process priority.
* Recursive agents (e.g. `dreamsync`, `planner`) internally maintain their own call stacks.
* All agents support ZeroMQ or DebugFS-based instrumentation.
* Future agents may include `axiom_introspector`, `axiom_simulator_gpu`, and `t729_reasoner`.

---

For symbolic tracing and replay, refer to `t81viz_plan.py` and `mirror_response` formats.

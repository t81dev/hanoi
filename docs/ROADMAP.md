# 🗺️ **HanoiVM — Project Roadmap (v0.9+)**

**HanoiVM** is a recursive, AI-augmented ternary virtual machine that executes symbolic logic across three cognitive computation tiers:

* `T81` — base ternary operand layer
* `T243` — symbolic state and recursive FSMs
* `T729` — tensor-based reasoning, AI logic, and planning

The system powers the **T81Lang** language, **Axion AI** kernel module, and **Alexis Linux**, emphasizing entropy-aware execution, symbolic planning, and AI-enhanced feedback mechanisms.

---

## ✅ Phase 0: Bootstrapping

* [x] Repository setup with structured CI (`ci.yml`)
* [x] Recursive ternary stack execution engine
* [x] Minimal `.hvm` assembler (`hvm_assembler.cweb`)
* [x] Literate `.cweb` infrastructure for all modules

---

## ✅ Phase 1: Core Virtual Machine (T81)

* [x] T81 operand spec (`uint81_t`, ternary tagging)
* [x] Stack-based virtual machine logic
* [x] Basic opcodes (`PUSH`, `POP`, `ADD`, `SUB`, `JMP`)
* [x] Entropy tracking + symbolic fallback error handling

---

## ✅ Phase 2: Recursive Expansion (T243/T729)

* [x] `T243BigInt`, `T729Tensor`, `T729HoloTensor` data types
* [x] Tensor operations: `reshape`, `contract`, `transpose`
* [x] Recursive symbolic FSM design
* [x] FFT-enabled ternary evaluation pipelines

---

## ✅ Phase 3: Compiler & Toolchain

* [x] Full compiler chain: `T81Lang` → `IR` → `TISC` → `.hvm`
* [x] `tisc_query_compiler.cweb` for NLP-driven compilation
* [x] Optimizing backend (`tisc_backend.cweb`)
* [x] REPL and symbolic standard library (`tisc_stdlib.cweb`)

---

## ✅ Phase 4: Axion AI Integration

* [x] `axion-ai.cweb`: Kernel module with symbolic AI core
* [x] NLP command dispatcher: `axionctl.cweb`
* [x] Symbolic memory + rollback (`/sys/kernel/debug/axion-ai`)
* [x] Stack entropy inspection, visualization, and planning

---

## ✅ Phase 5: Developer Tooling

* [x] `.cweb`-based introspection across all modules
* [x] Bytecode disassembler and visual log tracer
* [x] 3D recursion visualizer (`FrameSceneBuilder.cweb`)
* [x] JSON + CLI-based symbolic stack exporter

---

## 🔄 Phase 6: Logic & Visualization

* [x] GPU interface backends (CUDA / ROCm)
* [x] Symbolic tensor FFT pipelines (`T729HoloFFT`)
* [ ] `T729LogicGraph` for symbolic IR graph visualization
* [ ] Blockchain-style integrity logging for Axion logs
* [ ] Looking Glass — 3D symbolic debugger:

  * [ ] HUD for ternary stack state
  * [ ] Entropy timeline visualizer
  * [ ] Realtime AI telemetry streams

---

## 🔄 Phase 7: LLVM Optimization

* [x] T81 LLVM backend (`T81Target`, `T81InstrInfo.td`, etc.)
* [x] `i81` and symbolic IR dialect in MLIR
* [ ] Advanced symbolic opcode mapping in ISel DAGs
* [ ] Recursive LLVM pass for entropy analysis + loop unroll
* [ ] TISC ↔ LLVM round-trip IR pipeline

---

## 🔄 Phase 8: Packaging & CI/CD

* [x] `.cwebpkg` system for dependency management
* [x] Modular package builds via Axion AI agent
* [x] Release archive: `Release-v0.9-Public-Alpha.zip`
* [ ] Publishing of language/runtime toolchains
* [ ] Online CI/CD dashboards and test suite integrations

---

## ✅ Phase 9: Symbolic Query & Semantic AI

* [x] NLP-to-TISC symbolic compiler (`tisc_query_compiler.cweb`)
* [x] Entropy-based opcode scoring
* [x] Tier-based stack promotion engine (`recursive_tier_execution.cweb`)
* [ ] Reinforcement learning-based plan pruning
* [ ] GPU-assisted search for logic graph traversal

---

## 🔗 Ecosystem Projects

| Project                   | Purpose                                                |
| ------------------------- | ------------------------------------------------------ |
| **Alexis Linux**          | Modular AI OS with ternary native kernel               |
| **T81Lang**               | Ternary symbolic programming language                  |
| **Axion AI**              | Kernel-space symbolic AI and entropy stack interpreter |
| **Project Looking Glass** | Realtime 3D symbolic debugger and timeline visualizer  |

---

## ✨ Milestone Summary (v0.9)

* ✔ Full ternary symbolic tier stack (T81, T243, T729)
* ✔ NLP to opcode engine with entropy scoring
* ✔ Kernel-based Axion AI and planner agents
* ✔ CUDA + ROCm GPU tier integrations
* ✔ Interactive CLI, memory search, and visualization

> 🧠 Upcoming Focus:
>
> * Full `T729LogicGraph` with recursive 3D traversal
> * Expanded Grok integration for symbolic mirroring
> * TISC → LLVM pipeline export & round-trip verification
> * Entropy-stable AGI agent reflection tools
